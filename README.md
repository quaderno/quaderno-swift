# Quaderno

Quaderno is an Objective-C wrapper that provides easy access to the [Quaderno API](https://github.com/recrea/quaderno-api).


## Why Using It?

You can implement your own client for the [Quaderno API](https://github.com/quaderno/quaderno-api). However, by using Quaderno you have instant access to the same interface without messing around with low-level HTTP requests and JSON-encoded data.

Note that you need a valid account to use Quaderno.


## Supported OS & SDK Versions

* Supported build target - iOS 9.0 (Xcode 7.0, Apple LLVM compiler 5.0)
* Earliest supported deployment target - iOS 8.0
* Earliest compatible deployment target - iOS 8.0

*'Supported'* means that the library has been tested with this version. *'Compatible'* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


## Installation

Add Quaderno to your Podfile if you are using CocoaPods:

```ruby
pod "Quaderno", "~> 0.0.1"
```

Otherwise just drag the source files under the `Source` directory into your project.


## Usage


### Import Header Files

```objc
#import <QuadernoKit/QuadernoKit.h>
```


## Persistence

Quaderno doesn't automatically persist your objects for you.


## More Information

Remember that this is only a Objective-C wrapper for the original API. If you want more information about the API itself, head to the original [API documentation](https://github.com/quaderno/quaderno-api).


## Credits

Quaderno has been originally developed by [Eliezer Talón](https://github.com/elitalon).


## Contact

Follow Quaderno ([@quadernoapp](https://twitter.com/quadernoapp)) on Twitter.


## License

Quaderno is released under the MIT license. See [LICENSE.txt](https://github.com/quaderno/quaderno-ios/blob/master/LICENSE.txt).
