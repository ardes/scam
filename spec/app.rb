ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(:version => 0) do
    Scam.create_table :force => true
    
    create_table :products, :force => true do |t|
    end
    
    create_table :pages, :force => true do |t|
      t.string :type
    end
  end
end

class Product < ActiveRecord::Base
  has_scam
end

class Page < ActiveRecord::Base
  self.scam_class_name = 'MarukuScam'
  has_scams :content, :sidebar
end

class FunkyPage < Page
  has_scam :funk
  has_scam :simple, :class_name => 'Scam'
end
