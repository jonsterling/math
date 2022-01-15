# frozen_string_literal: true

# A tag to generate a [XXXXX] reference link to a node
class RefTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
    "<a href='#{site.baseurl}#{node.url}' class='slug'>[#{@slug}]</a>"
  end
end

Liquid::Template.register_tag('ref', RefTag)
