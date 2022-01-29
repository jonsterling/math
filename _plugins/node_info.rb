# frozen_string_literal: true

class NodeInfo
  def initialize(resource)
    @node = resource
  end

  def title
    @node["title"]
  end

  def slug
    @node["slug"]
  end

  def has_title?
    title != slug.downcase
  end

  def taxon
    @node["taxon"]
  end

  def genus
    if taxon == "section" then
      "Section"
    else
      @node["genus"] || "Result"
    end
  end

  def display_index
    "<span class='numbering'>#{genus} #{ToNumberingFilter.to_numbering @node['clicks']}</span>"
  end

  def display_title
    if taxon.nil? then
      title
    else
      display_index + (has_title? ? ". #{title}" : "")
    end
  end

  def display_title_parenthetical
    if taxon.nil? then
      title
    else
      display_index + (has_title? ? " (#{title})" : "")
    end
  end

  def aria_label
    if taxon.nil? then
      title
    else
      "#{genus} #{ToNumberingFilter.to_numbering @node['clicks']}." + (has_title? ? " #{title}" : "")
    end
  end
end


