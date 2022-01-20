require 'jekyll/sheafy/directed_graph'

module Sheafy
  def self.render_header(resource, level)
    slug = resource.data["slug"]
    title = resource.data["title"]
    numbering = resource.data["iso_2145"]
    href = "{{ '#{resource.url}' | relative_url }}"

    <<~HEADER
      <h#{level} id="#{slug}">
        <span class="numbering">#{numbering}.</span>
        #{title}
        <a class="slug" href="#{href}">[#{slug}]</a>
      </h#{level}>

    HEADER
  end

  RE_REF_TAG = /{%\s*ref (?<slug>.+?)\s*%}/

  def self.flatten_node(resource, resources, level=1, prepend_header=false)
    header = prepend_header ? render_header(resource, level) : ""
    flattened_subnodes = resource.data.fetch("subnodes", []).map do |slug|
      doc = resources.find { |doc| doc.data["slug"] == slug }
      flatten_node(doc, resources, level + 1, true)
    end
    header + resource.content + flattened_subnodes.join("\n")
  end

  def self.process_references(nodes, slugs_map)
    # The structure of references is a directed graph,
    # where source = referrer and target = referent.

    nodes.each do |source|
      source.content.scan(RE_REF_TAG).each do |(slug)|
        target = slugs_map[slug]
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

  def self.process_dependencies(nodes, slugs_map)
    # The structure of dependencies is a directed acyclic graph,
    # where source = parent and target = child.

    # First we build the adjacency list of the dependency graph...
    adjacency_list = nodes.map do |source|
      # TODO: subnodes and children are redundant; just drop one
      targets = source.data.fetch("subnodes", []).map(&slugs_map)
      # TODO: handle missing targets
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

    # Top. order is good to denormalize data from leaves up to roots,
    # i.e. to do destructive procedures which need the altered children.
    # tsorted_nodes.each { |resource| ... }
    #
    # Reversed top. order is good to denormalize data from roots down to leaves,
    # i.e. to do destructive procedures which need the original children.
    tsorted_nodes.reverse.each do |node|
      node.data["children"].each_with_index do |child, index|
        child.data["numbering"] = index + 1
      end

      node.data["ancestors"] = []
      if (parent = node.data["parents"].first)
        ancestors = [*parent.data["ancestors"], parent]
        node.data["ancestors"] = ancestors
        node.data["iso_2145"] = [*ancestors[1..], node].
          map { |n| n.data["numbering"] }.join(".")
      end
    end

    tsorted_nodes.reverse.each do |node|
      node.content = flatten_node(node, nodes)
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

  def self.process(nodes, slugs_map)
    process_references(nodes, slugs_map)
    process_dependencies(nodes, slugs_map)
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
  slugs_map = resources.map { |r| [r.data["slug"], r] }.to_h
  Sheafy.process(resources, slugs_map)
end
