platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

# Common dependencies for all targets
pod 'Alamofire', '~> 4.0'

# Extra dependencies for testing
target 'QuadernoTests' do
  OHHTTPStubsVersion = '~> 5.2'
  pod 'OHHTTPStubs', OHHTTPStubsVersion
  pod 'OHHTTPStubs/Swift', OHHTTPStubsVersion
end
