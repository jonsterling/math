module DisplayTitleFilter
  extend self

  def display_numbering(resource)
    info = NodeInfo.new resource
    info.display_numbering
  end

  def display_title(resource)
    info = NodeInfo.new resource
    info.display_title
  end

  def display_title_parenthetical(resource)
    info = NodeInfo.new resource
    info.display_title_parenthetical
  end

end

Liquid::Template.register_filter(DisplayTitleFilter)

