# frozen_string_literal: true

# TODO: this still exists only to avoid a crash with jekyll-feed, and we should find a better solution. This can mean ensuring jekyll-feed skips nodes, or choosind a different syntax for imports, or...
class ImportTag < Liquid::Tag
  def initialize(tag_name, slug, tokens)
  end

  def render(context)
  end
end

Liquid::Template.register_tag('import', ImportTag)
