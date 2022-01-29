# frozen_string_literal: true
#
class RefTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
    info = NodeInfo.new node.data
    "<a href='#{site.baseurl}#{node.url}' role='tooltip' aria-label='#{info.aria_label}' class='slug'>[#{@slug}]</a>"
  end
end

class CleverRefTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
    info = NodeInfo.new node.data
    "<a href='#{site.baseurl}#{node.url}' role='tooltip' aria-label='#{info.aria_label}' class='cref'>#{info.display_numbering} <span class='slug'>[#{@slug}]</span></a>"
  end
end

class ParenCleverRefTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
    super
    @slug = slug.strip
  end

  def render(context)
    registers = context.registers
    site = registers[:site]
    node = site.collections['nodes'].docs.detect { |doc| doc.data['slug'] == @slug }
    info = NodeInfo.new node.data
    "(<a href='#{site.baseurl}#{node.url}' role='tooltip' aria-label='#{info.aria_label}' class='cref'>#{info.display_numbering} <span class='slug'>[#{@slug}]</span></a>)"
  end
end


Liquid::Template.register_tag('ref', RefTag)
Liquid::Template.register_tag('cref', CleverRefTag)
Liquid::Template.register_tag('pref', ParenCleverRefTag)
