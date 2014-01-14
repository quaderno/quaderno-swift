# QuadernoKit

QuadernoKit is an Objective-C wrapper that provides easy access to the [Quaderno API](https://github.com/recrea/quaderno-api).


## Why Using It?

You can implement your own client for the [Quaderno API](https://github.com/recrea/quaderno-api). However, by using QuadernoKit you have instant access to the same interface without messing around with low-level HTTP requests and JSON-encoded data.

Note that you need a valid [Quaderno](https://quadernoapp.com) account to use QuadernoKit.


## Supported OS & SDK Versions

* Supported build target - iOS 7.0 (Xcode 5.0, Apple LLVM compiler 5.0)
* Earliest supported deployment target - iOS 6.1
* Earliest compatible deployment target - iOS 4.3

*'Supported'* means that the library has been tested with this version. *'Compatible'* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


## ARC Compatibility

QuadernoKit requires ARC. If you wish to use QuadernoKit in a non-ARC project, just add the -fobjc-arc compiler flag to the appropiate classes. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click on each class in the list and type -fobjc-arc into the popover.


## Installation

Add QuadernoKit to your Podfile if you are using CocoaPods:

```ruby
platform :ios, '7.0'
pod "QuadernoKit", "~> 0.0.1"
```

Otherwise just drag the `QuadernoKit` directory into your project.


## Usage


### Import Header Files

```objc
#import <QuadernoKit/QuadernoKit.h>
```


## Persistence

QuadernoKit doesn't automatically persist your objects for you.


## More Information

Remember that this is only a Objective-C wrapper for the original API. If you want more information about the API itself, head to the original [API documentation](https://github.com/recrea/quaderno-api).


## Credits

QuadernoKit has been originally developed by [Eliezer Talón](https://github.com/elitalon).


## Contact

Follow Quaderno ([@quadernoapp](https://twitter.com/quadernoapp)) on Twitter.


## License

QuadernoKit is released under the MIT license. See [LICENSE.txt](https://github.com/elitalon/QuadernoKit/blob/master/LICENSE.txt).
