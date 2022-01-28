# frozen_string_literal: true

# A tag to generate a [XXXXX] reference link to a node
class QedTag < Liquid::Tag
  def render(context)
    "<span style='float:right'>∎</span>"
  end
end

Liquid::Template.register_tag('qed', QedTag)

