Pod::Spec.new do |s|
  s.name               = 'Quaderno'
  s.version            = '2.0.0'
  s.license            = 'MIT'
  s.summary            = 'Swift wrapper for the Quaderno API.'
  s.homepage           = 'https://www.quaderno.io'
  s.social_media_url   = 'https://twitter.com/quadernoapp'
  s.authors            = {
    'Eliezer Talón'    => 'elitalon@gmail.com',
    'Carlos Hernández' => 'carlos@recreahq.com',
  }
  s.source             = { :git => 'https://github.com/quaderno/quaderno-swift.git', :tag => s.version }

  s.platform           = :ios, '10.0'
  s.requires_arc       = true
  s.source_files       = 'Source/**/*.swift'

  s.dependency 'Alamofire', '~> 4.0'
end
