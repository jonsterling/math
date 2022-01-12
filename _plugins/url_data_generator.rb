# frozen_string_literal: true

module Jekyll
  # A generator to embed the URL into each document's data object
  class UrlDataGenerator < Jekyll::Generator
    def generate(site)
      site.documents.each do |doc|
        doc.data['url'] = doc.url
      end
    end
  end
end
