Pod::Spec.new do |s|
  s.name                = 'QuadernoKit'
  s.version             = '0.0.1'
  s.license             = 'MIT'
  s.summary             = 'Objective-C wrapper for Quaderno API.'
  s.homepage            = 'https://github.com/elitalon/QuadernoKit'
  s.author              = { 'Eliezer Talón' => 'elitalon@gmail.com' }
  s.source              = { :git => 'https://github.com/elitalon/QuadernoKit.git', :tag => '0.0.1' }
  s.requires_arc        = true

  s.platform            = :ios, '6.1'

  s.public_header_files = 'QuadernoKit/*.h'
  s.source_files        = 'QuadernoKit/QuadernoKit.h'
end
