# frozen_string_literal: true
require 'cgi'

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

  # This is a very strange routine, but at least the logic is factored out here.
  def has_title?
    title != slug.downcase
  end

  def taxon
    @node["taxon"]
  end

  def numbering
    ToNumberingFilter.to_numbering @node["clicks"]
  end

  def genus
    if taxon == "section" then
      "Section"
    else
      @node["genus"] || "Result"
    end
  end

  def display_numbering
    "<span class='numbering'>#{genus} #{numbering}</span>"
  end

  def has_numbering?
    @node["depth"] != 0 && !taxon.nil?
  end

  def display_title
    has_numbering? ? (display_numbering + (has_title? ? ". #{title}" : "")) : title
  end

  def display_title_parenthetical
    has_numbering? ? (display_numbering + (has_title? ? " (#{title})" : "")) : title
  end

  def aria_label
    label = has_numbering? ? ("#{genus} #{numbering}." + (has_title? ? " #{title}" : "")) : title
    CGI.escapeHTML label
  end
end


