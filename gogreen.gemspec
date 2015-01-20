Gem::Specification.new do |s|
  s.name = 'gogreen'
  s.version = '0.1.1'
  s.summary = 'Run RSF jobs from the command line using a Dynarex flavoured aliases file.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('rscript', '~> 0.1', '>=0.1.27')
  s.add_runtime_dependency('dynarex', '~> 1.3', '>=1.3.5')
  s.add_runtime_dependency('acronym', '~> 0.1', '>=0.1.4')
  s.signing_key = '../privatekeys/gogreen.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/gogreen'
end
