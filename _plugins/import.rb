module Jekyll

  class PartialPage < Page
    def write?
      false
    end
  end

  class ImportTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = "_nodes/#{file.strip}"
    end

    def render(context)
      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Import file '#{@file}' contains invalid characters or sequences"
      end

      site = context.registers[:site]

      current_level = context.registers[:page]["level"] || 1

      choices = Dir['**/*'].reject { |x| File.symlink?(x) }
      if choices.include?(@file)
        partial = PartialPage.new(site, site.source, '', @file)
        partial.data["level"] = current_level + 1
        partial.data["target"] = File.basename(@file, File.extname(@file))
        partial.data["layout"] = "import";
        partial.render(site.layouts, site.site_payload)
        partial.output
      else
        raise "Import file '#{@file}' not found"
      end
    end
  end

end

Liquid::Template.register_tag('import', Jekyll::ImportTag)
