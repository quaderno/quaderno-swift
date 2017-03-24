platform :ios, '10.0'
inhibit_all_warnings!

target 'Quaderno' do
  use_frameworks!

  pod 'Alamofire', '~> 4.0'

  target 'QuadernoTests' do
    inherit! :search_paths

    OHHTTPStubsVersion = '~> 5.2'
    pod 'OHHTTPStubs', OHHTTPStubsVersion
    pod 'OHHTTPStubs/Swift', OHHTTPStubsVersion
  end
end
