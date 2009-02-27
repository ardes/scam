module Scam
  module Maruku
    def self.included(base)
      base.class_eval do
        include Scam unless included_modules.include?(Scam)
        self.default_content_type = :html
      end
    end
  
    def parse_to_html
      Maruku.new(content).to_html
    end
  
    def parse_to_string
      Maruku.new(content).to_s
    end
  end
end