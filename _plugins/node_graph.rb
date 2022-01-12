# frozen_string_literal: true

module Jekyll
  # A class to manage and synchronize the node dependency graph
  class NodeGraph
    def initialize(data)
      @data = data
      @toc = @data['toc'] || {}
      @cotoc = @data['cotoc'] || {}
      @referents = @data['referents'] || {}
      install_on data
    end

    def install_on(data)
      data['toc'] = @toc
      data['cotoc'] = @cotoc
      data['referents'] = @referents
    end

    def register_referent(slug, page)
      backlinks = @referents[slug] || []
      @referents[slug] = backlinks
      backlinks.append page unless backlinks.detect { |existing| existing['slug'] == page['slug'] }
    end

    def register_subpage(page, subpage)
      slug = page['slug']
      subslug = subpage['slug']

      toc = @toc[slug] || []
      @toc[slug] = toc

      cotoc = @cotoc[subslug] || []
      @cotoc[subslug] = cotoc

      toc.append subpage unless toc.detect { |existing| existing['slug'] == subslug }
      cotoc.append page unless cotoc.detect { |existing| existing['slug'] == slug }
    end
  end
end
