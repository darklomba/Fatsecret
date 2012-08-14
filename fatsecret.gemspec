Gem::Specification.new do |s|
  s.name        = 'fatsecret-api'
  s.version     = '0.1.0'
  s.date        = '2012-02-19'
  s.summary     = "Connects to FatSecret API and retreives nutritional data"
  s.description = "A simple hello world gem"
  s.authors     = ["Ibrahim Muhammad"]
  s.email       = 'ibrahim.mohammad@gmail.com'
  s.files       = ["lib/fatsecret.rb"]
  s.homepage    = 'http://www.github.com/whistler/fatsecret'
  
  s.add_runtime_dependency 'json', '~> 1.5'
  s.add_runtime_dependency 'activemodel', '~> 3.0'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'fakeweb'
end
