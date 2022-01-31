class NLabTag < Liquid::Tag
  def initialize(tag_name, title, tokens)
    super
    @title = title.strip
  end

  def render(context)
    page = @title.gsub(/\s/, '+')
    "<a href='http://ncatlab.org/nlab/show/#{page}'>#{@title}</a>"
  end
end

Liquid::Template.register_tag('nlab', NLabTag)
