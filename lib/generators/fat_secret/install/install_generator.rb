if defined? Rails
  module FatSecret
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def copy_initializer
          copy_file "fatsecret.rb", "config/initializers/fatsecret.rb" 
        end
      end
    end
  end
end
