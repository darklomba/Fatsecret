Gem::Specification.new do |s|
  s.name        = 'fatsecret-models'
  s.version     = '0.1.1'
  s.date        = '2012-08-21'
  s.summary     = "An active_model compliant wrapper for FatSecret API"
  s.description = "An active_model compliant wrapper for FatSecret API"
  s.authors     = ["Joseph Jackson", "Ibrahim Muhammad"]
  s.email       = 'cpmhjoe@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage    = 'http://www.github.com/joeyjoejoejr/fatsecret'
  
  s.add_runtime_dependency 'json', '~> 1.5'
  s.add_runtime_dependency 'activemodel', '~> 3.0'
  s.add_runtime_dependency 'active_attr'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'fakeweb'
end
