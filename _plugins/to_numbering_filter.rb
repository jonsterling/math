module ToNumberingFilter
  def to_numbering(clicks)
    label = ""
    # NOTE: we skip the first one because it's the lesson
    clicks[1..].each do |tick|
      label << case tick["clicker"]
        when "section" then ".#{tick["value"] + 1}"
        when "result" then "❋#{(tick["value"] + 97).chr}"
        else ".#{tick["value"]}"
      end
    end
    label[1..]
  end
end

Liquid::Template.register_filter(ToNumberingFilter)
