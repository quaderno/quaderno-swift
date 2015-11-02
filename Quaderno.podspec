Pod::Spec.new do |s|
  s.name               = 'Quaderno'
  s.version            = '0.0.2'
  s.license            = 'MIT'
  s.summary            = 'Swift wrapper for the Quaderno API.'
  s.homepage           = 'https://www.quaderno.io'
  s.social_media_url   = 'https://twitter.com/quadernoapp'
  s.authors            = {
    'Eliezer Talón'    => 'elitalon@gmail.com',
    'Carlos Hernández' => 'carlos@recreahq.com',
  }
  s.source             = { :git => 'https://github.com/quaderno/quaderno-ios.git', :tag => s.version }

  s.platform           = :ios, '9.0'
  s.requires_arc       = true
  s.source_files       = 'Source/*.swift'

  s.dependency 'Alamofire', '~> 3.0'
end
