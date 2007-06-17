require 'ardes/scam'
require 'maruku'

class MarukuScam < Scam
  self.default_content_type = :html
  
  def parse_to_html(content = self.content)
    maruku = Maruku.new(content)
    maruku.to_html
  end
end