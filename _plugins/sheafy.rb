require 'jekyll/sheafy/directed_graph'

module Sheafy
  RE_INCLUDE_TAG = /^@include{(?<slug>.+?)}$/
  RE_REF_TAG = /{%\s*ref (?<slug>.+?)\s*%}/
  SUBLAYOUT_KEY = "sublayout"
  SUBLAYOUT_DEFAULT_VALUE = "sheafy/node/default"
  TOPMOST_KEY = "topmost"
  TAXON_KEY = "sheafy"

  def self.apply_sublayout(resource, content, topmost)
    sublayout = resource.data.fetch(SUBLAYOUT_KEY, SUBLAYOUT_DEFAULT_VALUE)
    # NOTE: all this mess is just to adhere to Jekyll's internals
    site = resource.site
    payload = site.site_payload
    payload["page"] = resource.to_liquid
    payload["page"].merge!(TOPMOST_KEY => topmost)
    payload["content"] = content
    info = {
      :registers        => { :site => site, :page => payload["page"] },
      :strict_filters   => site.config["liquid"]["strict_filters"],
      :strict_variables => site.config["liquid"]["strict_variables"],
    }
    layout = site.layouts[sublayout]
    # TODO add_regenerator_dependencies(layout)
    template = site.liquid_renderer.file(layout.path).parse(layout.content)
    # TODO: handle warnings like https://github.com/jekyll/jekyll/blob/0b12fd26aed1038f69169b665818f5245e4f4b6d/lib/jekyll/renderer.rb#L126
    template.render!(payload, info)
    # TODO: handle exceptions like https://github.com/jekyll/jekyll/blob/0b12fd26aed1038f69169b665818f5245e4f4b6d/lib/jekyll/renderer.rb#L131
  end

  def self.flatten_subtree(resource, resources, topmost=true)
    content = resource.content.gsub(RE_INCLUDE_TAG) do
      doc = resources[Regexp.last_match[:slug]]
      # TODO: handle missing references
      flatten_subtree(doc, resources, false)
    end
    apply_sublayout(resource, content, topmost)
  end

  def self.process_references(nodes)
    # The structure of references is a directed graph,
    # where source = referrer and target = referent.

    nodes.values.each do |source|
      source.content.scan(RE_REF_TAG).each do |(slug)|
        target = nodes[slug]
        # TODO: handle missing targets
        target.data["referrers"] ||= []
        target.data["referrers"] << source
      end
    end

    # TODO: use a Set to avoid second pass
    nodes.values.each do |resource|
      resource.data["referrers"]&.uniq!
      resource.data["referrers"] ||= []
    end
  end

  def self.process_dependencies(nodes)
    # The structure of dependencies is a directed acyclic graph,
    # where source = parent and target = child.

    # First we build the adjacency list of the dependency graph...
    adjacency_list = nodes.values.map do |source|
      targets = source.content.scan(RE_INCLUDE_TAG).flatten.map(&nodes)
      # TODO: handle missing targets
      source.data["children"] = targets
      targets.each do |target|
        target.data["parent"] ||= source
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
      node.data["ancestors"] = []
      parent = node.data["parent"]
      node.data["depth"] = 1 + (parent&.data&.[]("depth") || -1)
      if parent
        ancestors = [*parent.data["ancestors"], parent]
        node.data["ancestors"] = ancestors
      end

      node.data["clicks"] ||= [
        { "clicker" => node.data["clicker"], "value" => 0 }]
      node.data["children"].
        group_by { |child| child.data["clicker"] }.
        each do |clicker, children|
          children.each_with_index do |child, index|
            clicks = node.data["clicks"].dup
            clicks << { "clicker" => clicker, "value" => index }
            child.data["clicks"] = clicks
          end
      end
    end

    tsorted_nodes.reverse.each do |node|
      node.content = flatten_subtree(node, nodes)
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

  def self.process(site)
    nodes = gather_node(site)
    nodes.values.each(&method(:apply_taxon))
    process_references(nodes)
    process_dependencies(nodes)
  end

  def self.gather_node(site)
    site.collections.values.flat_map(&:docs).
      filter { |doc| doc.data.key?(TAXON_KEY) }.
      map { |doc| [doc.data["slug"], doc] }.to_h
  end

  def self.apply_taxon(node)
    taxon_name = node.data[TAXON_KEY]
    taxon_data = node.site.config.dig("sheafy", "taxa", taxon_name) || {}
    # TODO: handle missing taxa
    node.data.merge!(taxon_data) { |key, left, right| left }
  end

  # TODO: handle regenerator dependencies
  # if page&.key?('path')
  #   path = site.in_source_dir(source['path'])
  #   dependency = site.in_source_dir(targets.path)
  #   site.regenerator.add_dependency(path, dependency)
  # end
end

Jekyll::Hooks.register :site, :post_read, priority: 30 do |site|
  Sheafy.process(site)
end
