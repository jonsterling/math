# This code is roughly based on https://github.com/koraktor/jekyll/tree/import-tag

# frozen_string_literal: true

module Jekyll
  # A version of `Page` that is meant to be rendered but not written.
  class ImportedPage < Page

    def initialize(site, base, dir, name, superpage:)
      super(site, base, dir, name)
      data['slug'] = basename
      data['level'] = (superpage['level'] || 1) + 1
      data['layout'] = 'import'
    end

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
      subpages = @toc[slug] || []
      @toc[slug] = subpages
      subpages.append subpage unless subpages.detect { |existing| existing['slug'] == subpage['slug'] }
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

      referent = site.documents.find { |doc| doc.data['slug'] == @slug }
      NodeGraph.new(site.data).register_subpage(page, referent.data)
      imported = ImportedPage.new(site, site.source, '_nodes', "#{@slug}.md", superpage: page)

      # tracks dependencies like Jekyll::Tags::IncludeTag so --incremental works
      if page&.key?('path')
        path = site.in_source_dir(page['path'])
        dependency = site.in_source_dir(imported.path)
        site.regenerator.add_dependency(path, dependency)
      end

      imported.render(site.layouts, site.site_payload)
      imported.output
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
      NodeGraph.new(site.data).register_referent(@slug, registers[:page])
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
