require 'ardes/scam'
require 'maruku'

class MarukuScam < Scam
  self.default_content_type = :html
  
  def parse_to_html(content = self.content)
    Maruku.new(content).to_html
  end
  
  def parse_to_string(content = self.content)
    Maruku.new(content).to_s
  end
end