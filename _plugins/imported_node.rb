# frozen_string_literal: true

module Jekyll
  # A version of `Page` that is meant to be rendered but not written.
  class ImportedNode < Page
    def initialize(site, base, name, superpage:)
      dir = '_nodes'
      super(site, base, dir, name)
      data['slug'] = basename
      data['level'] = (superpage['level'] || 1) + 1
      data['layout'] = 'import'
      data['collection'] = 'nodes'
    end

    def url
      "/nodes/#{basename}.html"
    end

    def write?
      false
    end
  end
end
