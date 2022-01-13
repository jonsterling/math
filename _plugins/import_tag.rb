# This code is roughly based on https://github.com/koraktor/jekyll/tree/import-tag
#
# frozen_string_literal: true

class ImportTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    page = registers[:page]
    index = (page['import_count'] || 0) + 1
    page['import_count'] = index

    index_str = (page['index_str'] || "") + "#{index}."
    imported = Jekyll::ImportedNode.new(site, site.source, "#{@slug}.md", superpage: page, index_str: index_str)
    Jekyll::NodeGraph.new(site.data).register_subpage(page, imported)

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

Liquid::Template.register_tag('import', ImportTag)
