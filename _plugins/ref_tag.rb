# frozen_string_literal: true
#
class RefTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render_node(node, info, url)
    "<a href='#{url}' role='tooltip' aria-label='#{info.aria_label}' class='slug'>[#{@slug}]</a>"
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
    info = NodeInfo.new node.data
    url = "#{site.baseurl}#{node.url}"
    render_node(node, info, url)
  end
end

class CleverRefTag < RefTag
  def render_node(node, info, url)
    "<a href='#{url}' role='tooltip' aria-label='#{info.aria_label}' class='cref'>#{info.display_numbering} <span class='slug'>[#{@slug}]</span></a>"
  end
end

class ParenCleverRefTag < CleverRefTag
  def render_node(node, info, url)
    "(#{super})"
  end
end


Liquid::Template.register_tag('ref', RefTag)
Liquid::Template.register_tag('cref', CleverRefTag)
Liquid::Template.register_tag('pref', ParenCleverRefTag)
