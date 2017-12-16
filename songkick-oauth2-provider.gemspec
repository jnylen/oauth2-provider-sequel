Gem::Specification.new do |s|
  s.name              = 'songkick-oauth2-provider'
  s.version           = '0.10.3'
  s.summary           = 'Simple OAuth 2.0 provider toolkit'
  s.author            = 'James Coglan'
  s.email             = 'james@songkick.com'
  s.homepage          = 'http://github.com/songkick/oauth2-provider'

  s.extra_rdoc_files  = %w[README.rdoc]
  s.rdoc_options      = %w[--main README.rdoc]

  s.files             = %w[History.txt README.rdoc] + Dir.glob('{example,lib,spec}/**/*.{css,erb,rb,rdoc,ru}')
  s.require_paths     = ['lib']

  s.add_dependency 'sequel'
  s.add_dependency 'sequel_polymorphic'
  s.add_dependency 'activemodel'
  s.add_dependency 'bcrypt'
  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'as-duration'

  s.add_development_dependency 'appraisal', '~> 0.4.0'
  s.add_development_dependency 'factory_girl', '~> 2.0'
  s.add_development_dependency 'i18n', '~> 0.6.4'
  s.add_development_dependency 'pg', '~> 0.18.4'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sinatra', '~> 1.3'
  s.add_development_dependency 'thin'
  s.add_development_dependency 'dotenv'
end
