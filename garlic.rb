# typical rspec garlic configuration

garlic do
  # this plugin
  repo "scam", :path => '.'
  
  # other repos
  repo "rails", :url => "git://github.com/rails/rails"
  repo "rspec", :url => "git://github.com/dchelimsky/rspec"
  repo "rspec-rails", :url => "git://github.com/dchelimsky/rspec-rails"
  
  # target railses
  ['master', '2-2-stable', '2-1-stable', '2-0-stable'].each do |rails|
    
    # declare how to prepare, and run each CI target
    target rails, :branch => "origin/#{rails}" do
      prepare do
        plugin "scam", :clone => true # so we can work in targets
        plugin "rspec"
        plugin "rspec-rails" do
          `script/generate rspec -f`
        end
      end
    
      run do
        cd "vendor/plugins/scam" do
          sh "rake"
        end
      end
    end
  end
end
