require 'ardes/scam'
require 'maruku'

class MarukuScam < Scam
  self.default_content_type = :html
  
  def parse_to_html
    Maruku.new(content).to_html
  end
  
  def parse_to_string
    Maruku.new(content).to_s
  end
end