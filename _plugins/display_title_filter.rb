module DisplayTitleFilter
  extend self

  def display_index(resource)
    info = NodeInfo.new resource
    info.display_index
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

