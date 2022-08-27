# frozen_string_literal: true

module Antex
  class Job
    include LiquidHelpers

    def prepare_code
      @code = liquid_render @options['template'],
                            'preamble' => @options['preamble'],
                            'append' => @options['append'],
                            'prepend' => @options['prepend'],
                            'macrolib' => @options['macrolib'],
                            'snippet' => @snippet
    end
  end
end
