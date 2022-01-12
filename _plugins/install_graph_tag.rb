# frozen_string_literal: true

# A tag to install the current node dependency graph on the current page object
class InstallGraphTag < Liquid::Tag
  def render(context)
    registers = context.registers
    site = registers[:site]
    page = registers[:page]
    Jekyll::NodeGraph.new(site.data).install_on page
    nil
  end
end

Liquid::Template.register_tag('install_graph', InstallGraphTag)
