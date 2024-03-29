Gem::Specification.new do |s|
  s.name = 'gogreen'
  s.version = '0.4.0'
  s.summary = 'Run RSF jobs from the command line using a Dynarex flavoured ' + 
      'aliases file.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/gogreen.rb']
  s.add_runtime_dependency('rscript', '~> 0.9', '>=0.9.0')
  s.add_runtime_dependency('dynarex', '~> 1.9', '>=1.9.5')
  s.add_runtime_dependency('acronym', '~> 0.1', '>=0.1.4')
  s.add_runtime_dependency('polyrex', '~> 1.4', '>=1.4.0')
  s.add_runtime_dependency('optparse-simple', '~> 0.4', '>=0.4.5')
  s.signing_key = '../privatekeys/gogreen.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/gogreen'
end
