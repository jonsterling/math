module RefGenerator

  LABEL_REGEX = /{\s*#([A-Za-z0-9\-\_]+)\s*}/

  class Generator < Jekyll::Generator
    priority :low
    def generate(site)
      docs = site.collections["lectures"].docs


      keymap = {}

      docs.each do |doc|
        lbl = doc.data['label']
        if lbl then

          sublbls = doc.content.scan(LABEL_REGEX).flatten

          keymap[lbl] = {
            :data => doc.data,
            :url => site.baseurl + doc.url,
          }

          sublbls.each do |sublbl|
            keymap[lbl][sublbl] = {
              :url => site.baseurl + doc.url + "#" + sublbl
            }
          end

        end
      end

      # print keymap

      docs.each do |doc|
        doc.data['refs'] = keymap
      end
    end
  end
end

module RefFilter
  def link(input)
    url = input[:url]
    title = input[:data]['title']
    "<a href='#{url}'>#{title}</a>"
  end

  def url(input)
    input[:url]
  end
end

Liquid::Template.register_filter(RefFilter)

