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

    def initialize(site_data)
      @site_data = site_data

      @toc = @site_data['toc'] || {}
      @site_data['toc'] = @toc

      @cotoc = @site_data['cotoc'] || {}
      @site_data['cotoc'] = @cotoc
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

      site = context.registers[:site]
      page = context.registers[:page]

      current_level = page['level'] || 1

      referent = site.documents.find {|d| d.data['slug'] == @slug }

      toc = NodeGraph.new site.data
      toc.register_subpage(page['slug'],referent.data)

      file = "_nodes/#{@slug}.md"
      partial = PartialPage.new(site, site.source, '', file)
      partial.data['level'] = current_level + 1
      partial.data['url'] = "#{site.baseurl}/nodes/#{@slug}.html"
      partial.data['layout'] = 'import'
      partial.data['slug'] = @slug

      # tracks dependencies like Jekyll::Tags::IncludeTag so --incremental works
      if context.registers[:page]&.key?('path')
        path = site.in_source_dir(context.registers[:page]['path'])
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
      site = context.registers[:site]
      page = context.registers[:page]
      nodes = site.collections['nodes'].docs
      node = nodes.detect {|d| d.data['slug'] == @slug}

      gph = NodeGraph.new site.data
      gph.register_backlink(@slug,page)

      "<a href='#{site.baseurl}#{node.url}' class='slug'>[#{@slug}]</a>"
    end

  end


  class GenerateBacklinksTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]

      gph = NodeGraph.new site.data
      page['toc'] = gph.toc
      page['cotoc'] = gph.cotoc

      all_docs = site.documents

      superpages = all_docs.filter do |e|
        subpages = gph.toc[e['slug']] || []
        subpages.detect {|p| p['slug'] == page['slug']}
      end

      if superpages == [] then superpages = nil end
      page['superpages'] = superpages
      nil
    end

  end



end

Liquid::Template.register_tag('generate_backlinks', Jekyll::GenerateBacklinksTag)
Liquid::Template.register_tag('import', Jekyll::ImportTag)
Liquid::Template.register_tag('ref', Jekyll::RefTag)
