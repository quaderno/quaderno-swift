# Quaderno

[![Build Status](https://travis-ci.org/quaderno/quaderno-swift.svg)](https://travis-ci.org/quaderno/quaderno-swift)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Quaderno.svg)](https://img.shields.io/cocoapods/v/Quaderno.svg)
[![Platform](https://img.shields.io/cocoapods/p/Quaderno.svg?style=flat)](http://cocoadocs.org/docsets/Quaderno)
[![Twitter](https://img.shields.io/badge/twitter-@quadernoapp-blue.svg?style=flat)](https://twitter.com/quadernoapp)

Quaderno is a Swift framework that provides easy access to the [Quaderno API](https://github.com/recrea/quaderno-api).


## Why Using It?

You can implement your own client for the [Quaderno API](https://github.com/quaderno/quaderno-api). However, using [Quaderno](https://github.com/quaderno/quaderno-swift) gives you instant access to the same interface without messing around with low-level HTTP requests and JSON-encoded data.

Note that you need a valid account to use Quaderno.


## Supported OS & SDK Versions

* Supported build target - iOS 9.0
* Earliest supported deployment target - iOS 9.0
* Earliest compatible deployment target - iOS 8.0

*'Supported'* means that the library has been tested with this version. *'Compatible'* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


## Installation

Add Quaderno to your Podfile if you are using CocoaPods:

```ruby
pod "Quaderno", "~> 1.0.0"
```

Otherwise just drag the `.swift` source files under the `Source` directory into your project.

> **Embedded frameworks require a minimum deployment target of iOS 8.**
>
> To use Quaderno with application targets that do not support embedded frameworks, such as iOS 7, you must include all source files directly in your project.


## Usage

In order to make requests you need to instantiate at least one `Client` object, providing a base URI for building resource paths and your authentication token:

```swift
let client = Quaderno.Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "my token")
```

All requests are done asynchronously, as explained in this [excerpt from Alamofire's README](https://github.com/Alamofire/Alamofire/blob/master/README.md):

> Networking [...] is done _asynchronously_. Asynchronous programming may be a source of frustration to programmers unfamiliar with the concept, but there are [very good reasons](https://developer.apple.com/library/ios/qa/qa1693/_index.html) for doing it this way.

> Rather than blocking execution to wait for a response from the server, a [callback](http://en.wikipedia.org/wiki/Callback_%28computer_programming%29) is specified to handle the response once it's received. The result of a request is only available inside the scope of a response handler. Any execution contingent on the response or data received from the server must be done within a handler.

### Importing the Module

Import the Quaderno module as you would normally include any Swift module:

```swift
import Quaderno
```

### Checking the Service Availability

You can ping the service in order to check whether it is available:

```swift
let client = Quaderno.Client(/* ... */)
client.ping { success in
  // success will be true if the service is available.
}
```

### Fetching the Account Credentials

You can fetch the account credentials for a given user:

```swift
let client = Quaderno.Client(/* ... */)
client.account { credentials in
  // credentials will contain the account credentials.
}
```

See [`AccountCredentials`](https://github.com/quaderno/quaderno-swift/blob/master/Source/AccountCredentials.swift) for further details.

### Requesting Resources

You can request any resource using the `request(_:completion)` function:

```swift
let client = Quaderno.Client(/* ... */)

let readContact = Contact.read(48)
client.request(readContact) { response in
  // response will contain the result of the request.
}
```

The first parameter must be an object conforming to the [`Request`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Request.swift) protocol. For convenience, Quaderno already provides a set of default resources conforming to it (e.g. `Ping`, `Contact`,...).

Moreover, Quaderno also provides different behaviours for implementing common operations on different resources (e.g. `CRUD`, `SingleRequest`,...).

For further details check also [`Resource`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Response.swift) and [`Response`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Response.swift).

### Connection Entitlements

You can check the entitlements for using the service (e.g. the rate limit) by inspecting the `entitlements` property of `Client`.

See [`ConnectionEntitlements`](https://github.com/quaderno/quaderno-swift/blob/master/Source/ConnectionEntitlements.swift) for further details.


## Persistence

Quaderno does not automatically persist your objects for you.


## Development

###Getting Started

Quaderno uses [CocoaPods](http://cocoapods.org) to manage dependencies. See `Podfile` to get a comprehensive list of dependencies.

After cloning this repository run the following commands:

```bash
pod install
```

If you need another option for managing dependencies (e.g. Carthage), please open an issue to discuss it.

###Project Structure

The entry point for the project is the `Quaderno.xcworkspace` file, which contains two projects:

1. `Quaderno.xcodeproj`, with the source code of the framework.
2. `Pods.xcodeproj`, with third-party dependencies automatically managed by CocoaPods.

###Documentation

The source code is fully documented using the markup formatting commands defined by Apple.

An [HTML version of the documentation](http://cocoadocs.org/docsets/Quaderno) can be found at [CocoaDocs](http://cocoadocs.org).


## More Information

Remember that this is only a Swift wrapper for the original API. If you want more information about the API itself, head to the original [API documentation](https://github.com/quaderno/quaderno-api).


## Credits

Quaderno has been originally developed by [Eliezer Talón](https://github.com/elitalon).


## Contact

Follow Quaderno ([@quadernoapp](https://twitter.com/quadernoapp)) on Twitter.


## License

Quaderno is released under the MIT license. See [LICENSE.txt](https://github.com/quaderno/quaderno-swift/blob/master/LICENSE.txt).
