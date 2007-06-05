ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(:version => 0) do
    Scam.create_table :force => true
    Con.create_table :force => true
    
    create_table :products, :force => true do |t|
    end
    
    create_table :page, :force => true do |t|
    end
  end
end

class Product < ActiveRecord::Base
  has_scam
end

class Page < ActiveRecord::Base
  has_scams :content, :sidebar
end

class FunkyPage < Page
  has_scam :funk
end
