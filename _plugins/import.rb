module Jekyll

  class PartialPage < Page
    def write?
      false
    end
  end

  class TOC
    def initialize(site)
      @site = site
    end

    def get_toc_object()
      if @site.data["toc"] == nil then
        @site.data["toc"] = {}
      end

      @site.data["toc"]
    end

    def get_subpages(slug)
      toc = get_toc_object()
      subpages = toc[slug]
      unless subpages
        subpages = []
        toc[slug] = subpages
      end
      subpages
    end

    def register_subpage(slug, subpage)
      subpages = get_subpages slug

      unless subpages.detect {|x| x["slug"] == subpage["slug"]}
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

      current_level = page["level"] || 1

      referent = site.documents.find {|d| d.data["slug"] == @slug }

      toc = TOC.new site
      toc.register_subpage(page["slug"],referent.data)

      file = "_nodes/#{@slug}.md"
      partial = PartialPage.new(site, site.source, '', file)
      partial.data["level"] = current_level + 1
      partial.data["url"] = "#{site.baseurl}/nodes/#{@slug}.html"
      partial.data["layout"] = "import"
      partial.data["slug"] = @slug
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
      nodes = site.collections["nodes"].docs
      node = nodes.detect {|d| d.data["slug"] == @slug}

      referents = page["referents"]
      unless referents
        referents = []
        page["referents"] = referents
      end

      unless referents.include? @slug
        referents.append @slug
      end

      "<a href='#{site.baseurl}#{node.url}' class='slug'>[#{@slug}]</a>"
    end

  end


  class BacklinksTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]
      page["toc"] = TOC.new(site).get_toc_object()

      all_docs = site.documents

      superpages = all_docs.filter do |e|
        subpages = site.data["toc"][e["slug"]] || []
        subpages.detect {|p| p["slug"] == page["slug"]}
      end

      referrers = all_docs.filter do |e|
        referents = e["referents"] || []
        referents.detect {|slug| slug == page["slug"]}
      end

      if superpages == [] then superpages = nil end
      if referrers == [] then referrers = nil end

      page["referrers"] = referrers
      page["superpages"] = superpages
      nil
    end

  end



end

Liquid::Template.register_tag('generate_backlinks', Jekyll::BacklinksTag)
Liquid::Template.register_tag('import', Jekyll::ImportTag)
Liquid::Template.register_tag('ref', Jekyll::RefTag)
