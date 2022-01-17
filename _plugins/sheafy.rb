require 'jekyll/sheafy/directed_graph'

module Sheafy
  def self.render_header(resource, level)
    slug = resource.data["slug"]
    title = resource.data["title"]
    href = "{{ '#{resource.url}' | relative_url }}"

    <<~HEADER
      <h#{level} id="#{slug}">
        #{title}
        <a class="slug" href="#{href}">[#{slug}]</a>
      </h#{level}>

    HEADER
  end

  RE_INCLUDE_TAG = /^@include{(?<slug>.+?)}$/
  RE_REF_TAG = /{%\s*ref (?<slug>.+?)\s*%}/

  def self.flatten_imports(resource, resources, level=1, prepend_header=false)
    header = prepend_header ? render_header(resource, level) : ""
    content = resource.content.gsub(RE_INCLUDE_TAG) do
      doc = resources.
        find { |doc| doc.data["slug"] == Regexp.last_match[:slug] }
      flatten_imports(doc, resources, level + 1, true)
    end
    header + content
  end

  def self.process_references(nodes)
    # The structure of references is a directed graph,
    # where source = referrer and target = referent.

    nodes.each do |source|
      source.content.scan(RE_REF_TAG).each do |(slug)|
        target = nodes.find { |r| r.data["slug"] == slug }
        # TODO: handle missing targets
        target.data["referrers"] ||= []
        target.data["referrers"] << source
      end
    end

    # TODO: use a Set to avoid second pass
    nodes.each do |resource|
      resource.data["referrers"]&.uniq!
      resource.data["referrers"] ||= []
    end
  end

  def self.process_dependencies(nodes)
    # The structure of dependencies is a directed acyclic graph,
    # where source = parent and target = child.

    # First we build the adjacency list of the dependency graph...
    adjacency_list = nodes.map do |source|
      targets = source.content.scan(RE_INCLUDE_TAG).map do |(slug)|
        # TODO: handle missing targets
        nodes.find { |target| target.data["slug"] == slug }
      end
      source.data["children"] = targets
      source.data["parents"] ||= []
      targets.each do |target|
        target.data["parents"] ||= []
        target.data["parents"] << source
      end
      [source, targets]
    end.to_h

    # ... then we build the graph and do a topological sort on the nodes.
    graph = Jekyll::Sheafy::DirectedGraph[adjacency_list]
    begin
      graph.ensure_rooted_forest!
    rescue Jekyll::Sheafy::DirectedGraph::PayloadError => error
      humanize_sheafy_error!(error)
    end
    tsorted_nodes = graph.topologically_sorted
    
    # TODO: catch TSort::Cyclic and provide meaningful message

    # Top. order is good to denormalize data from leaves up to roots,
    # i.e. to do destructive procedures which need the altered children.
    # tsorted_nodes.each { |resource| ... }

    # Reversed top. order is good to denormalize data from roots down to leaves,
    # i.e. to do destructive procedures which need the original children.
    tsorted_nodes.reverse.each do |node|
      node.content = flatten_imports(node, nodes)
    end
  end

  def self.humanize_sheafy_error!(error)
    message = case error
      when Jekyll::Sheafy::DirectedGraph::MultipleEdgesError then "node reuse"
      when Jekyll::Sheafy::DirectedGraph::LoopsError then "self reference"
      when Jekyll::Sheafy::DirectedGraph::CyclesError then "cyclic reference"
      when Jekyll::Sheafy::DirectedGraph::IndegreeError then "node reuse"
      else raise StandardError.new("Malformed dependency graph!")
    end
    graph_fragment = case error
      when Jekyll::Sheafy::DirectedGraph::MultipleEdgesError,
           Jekyll::Sheafy::DirectedGraph::LoopsError,
           Jekyll::Sheafy::DirectedGraph::IndegreeError
        error.payload.
          transform_keys { |k| k.data["slug"] }.
          transform_values { |vs| vs.map { |v| v.data["slug"] } }
      when Jekyll::Sheafy::DirectedGraph::CyclesError
        error.payload.map { |vs| vs.map { |v| v.data["slug"] } }
      end
    raise StandardError.new(<<~MESSAGE)
      Error in dependency graph topology, #{message} detected: #{graph_fragment}
    MESSAGE
  end

  def self.process(nodes)
    process_references(nodes)
    process_dependencies(nodes)
  end

  # TODO: handle regenerator dependencies
  # if page&.key?('path')
  #   path = site.in_source_dir(source['path'])
  #   dependency = site.in_source_dir(targets.path)
  #   site.regenerator.add_dependency(path, dependency)
  # end
end

Jekyll::Hooks.register :site, :post_read, priority: 30 do |site|
  resources = site.collections.
    values_at("nodes", "lectures").
    map(&:docs).flatten
  Sheafy.process(resources)
end
