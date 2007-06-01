ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(:version => 0) do
    Scammer.scam_class.create_table :force => true

    create_table :products, :force => true do |t|
    end
    
    create_table :page, :force => true do |t|
    end
  end
end

class PageScam < Scammer.scam_class
end

class Product < ActiveRecord::Base
  has_scam
end

class Page < ActiveRecord::Base
  self.scam_class_name = 'PageScam'
  has_scams :content, :sidebar
end

class FunkyPage < Page
  has_scam :funk
  has_scams :normal, :class_name => 'Scam'
end
