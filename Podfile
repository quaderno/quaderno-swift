platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

# Common dependencies for all targets
pod 'Alamofire', '~> 3.0'

# Extra dependencies for testing
target 'QuadernoTests' do
  OHHTTPStubsVersion = '~> 4.0'
  pod 'OHHTTPStubs', OHHTTPStubsVersion
  pod 'OHHTTPStubs/Swift', OHHTTPStubsVersion
end
