# This code is roughly based on https://github.com/koraktor/jekyll/tree/import-tag

# frozen_string_literal: true

module Jekyll
  # A version of `Page` that is meant to be rendered but not written.
  class PartialPage < Page
    def write?
      false
    end
  end

  class NodeGraph
    attr_reader :toc, :cotoc

    def initialize(data)
      @data = data
      @toc = @data['toc'] || {}
      @cotoc = @data['cotoc'] || {}
      install_on data
    end

    def install_on(data)
      data['toc'] = @toc
      data['cotoc'] = @cotoc
    end

    def get_subpages(slug)
      subpages = @toc[slug]
      unless subpages
        subpages = []
        @toc[slug] = subpages
      end
      subpages
    end

    def get_backlinks(slug)
      backlinks = @cotoc[slug]
      unless backlinks
        backlinks = []
        @cotoc[slug] = backlinks
      end
      backlinks
    end

    def register_backlink(slug, page)
      backlinks = get_backlinks slug

      unless backlinks.detect {|x| x['slug'] == page['slug']}
        backlinks.append page
      end
    end


    def register_subpage(slug, subpage)
      subpages = get_subpages slug

      unless subpages.detect {|x| x['slug'] == subpage['slug']}
        subpages.append subpage
      end
    end

  end

  class ImportTag < Liquid::Tag
    def initialize(tag_name, slug, tokens)
      super
      @slug = slug.strip
    end

    def render(context)
      registers = context.registers
      site = registers[:site]
      page = registers[:page]

      referent = site.documents.find {|doc| doc.data['slug'] == @slug }

      NodeGraph.new(site.data).register_subpage(page['slug'], referent.data)

      file = "_nodes/#{@slug}.md"
      partial = PartialPage.new(site, site.source, '', file)
      partial_data = partial.data
      partial_data['level'] = (page['level'] || 1) + 1
      partial_data['layout'] = 'import'
      partial_data['slug'] = @slug

      # tracks dependencies like Jekyll::Tags::IncludeTag so --incremental works
      if page&.key?('path')
        path = site.in_source_dir(page['path'])
        dependency = site.in_source_dir(file)
        site.regenerator.add_dependency(path, dependency)
      end

      partial.render(site.layouts, site.site_payload)

      partial.output
    end
  end

  class RefTag < Liquid::Tag
    def initialize(tag_name, slug, tokens)
      super
      @slug = slug.strip
    end

    def render(context)
      registers = context.registers
      site = registers[:site]
      node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
      NodeGraph.new(site.data).register_backlink(@slug, registers[:page])
      "<a href='#{site.baseurl}#{node.url}' class='slug'>[#{@slug}]</a>"
    end
  end


  class GenerateBacklinksTag < Liquid::Tag
    def render(context)
      registers = context.registers
      site = registers[:site]
      page = registers[:page]

      gph = NodeGraph.new site.data
      gph.install_on page

      all_docs = site.documents

      superpages = all_docs.filter do |doc|
        gph.toc[doc.data['slug']]&.detect { |subpage| subpage['slug'] == page['slug'] }
      end

      # Working around some strange Liquid behavior
      superpages = nil if superpages == []
      page['superpages'] = superpages
      nil
    end
  end
end

Liquid::Template.register_tag('generate_backlinks', Jekyll::GenerateBacklinksTag)
Liquid::Template.register_tag('import', Jekyll::ImportTag)
Liquid::Template.register_tag('ref', Jekyll::RefTag)
