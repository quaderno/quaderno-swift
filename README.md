# Quaderno

[![Build Status](https://travis-ci.org/quaderno/quaderno-swift.svg)](https://travis-ci.org/quaderno/quaderno-swift)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Quaderno.svg)](https://img.shields.io/cocoapods/v/Quaderno.svg)
[![Platform](https://img.shields.io/cocoapods/p/Quaderno.svg?style=flat)](http://cocoadocs.org/docsets/Quaderno)
[![Twitter](https://img.shields.io/badge/twitter-@quadernoapp-blue.svg?style=flat)](https://twitter.com/quadernoapp)

Quaderno is a Swift framework that provides easy access to the [Quaderno API](https://quaderno.io/docs/api/).


## Why Using It?

You can implement your own client for the [Quaderno API](https://quaderno.io/docs/api/). However, using [quaderno-swift](https://github.com/quaderno/quaderno-swift) gives you instant access to the same interface without the details of HTTP requests and responses.

Note that you need a valid account to use Quaderno.


## Supported OS & SDK Versions

* Supported build target - iOS 10.x
* Earliest supported deployment target - iOS 9.0
* Earliest compatible deployment target - iOS 9.0

*'Supported'* means that the library has been tested with this version. *'Compatible'* means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


## Installation

Add Quaderno to your Podfile if you are using CocoaPods:

```ruby
pod "Quaderno", "~> 2.0"
```

Otherwise just drag the `.swift` source files under the `Source` directory into your project.

> **Embedded frameworks require a minimum deployment target of iOS 8.**
>
> To use Quaderno with application targets that do not support embedded frameworks, such as iOS 7, you must include all source files directly in your project.


## Usage

In order to make requests you need to instantiate at least one `Client` object, providing a base URL for building resource paths and your authentication token:

```swift
let client = Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "your token")
```

All requests are done asynchronously, as explained in [Alamofire's README](https://github.com/Alamofire/Alamofire#response-handling).

### Importing the Module

Import the Quaderno module as you would normally include any Swift module:

```swift
import Quaderno
```

### Checking the Service Availability

You can ping the service in order to check whether it is available:

```swift
let client = Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "your token")
client.ping { error in
  // error will be nil if the service is available.
}
```

### Fetching the Account Credentials

You can fetch the account credentials for a given user:

```swift
let client = Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "your token")
client.account { result in
  // result will contain either an error or a JSON object with the account information.
}
```

See the ["Authorization" section](https://quaderno.io/docs/api/#authorization) on the Quaderno API for further details.

### Requesting Resources

You can request any supported resource using the `send(_:completion)` function:

```swift
let client = Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "your token")

let request = Contact.request(.read(48))
client.send(request) { response in
  // response will contain either an error or the response to the request.
}
```

The first parameter must be an object conforming to the [`Request`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Request.swift) protocol.

For convenience, Quaderno already provides a set of default resources (`ContactResource`, `InvoiceResource`,…) that adopt `Request` and provide requests for common behaviours (`CRUDResource`, `DeliverableResource`,…). For further details check also [`Resource`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Resource.swift) protocol.

The second parameter is a closure that receives a generic [`Response`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Response.swift) as only parameter. The type of the response is inferred at compilation depending on what you provide. Quaderno will try to cast the response received by the server to the type you indicate:

```swift
let client = Client(baseURL: "https://quadernoapp.io/api/v1/", authenticationToken: "your token")

let request = Contact.request(.read(48))
client.send(request) { (response: Response<[String: Any]>) in
  // response will contain either an error or a dictionary.
}
```

### Connection Entitlements

You can check the entitlements for using the service (e.g. the rate limit) by inspecting the `entitlements` property of `Client`.

See the [`Client.Entitlements`](https://github.com/quaderno/quaderno-swift/blob/master/Source/Client.swift) struct for further details.


## Persistence

Quaderno does not automatically persist your objects for you.


## Development

### Getting Started

Quaderno uses [CocoaPods](http://cocoapods.org) to manage dependencies. See `Podfile` to get a comprehensive list of dependencies.

After cloning this repository run the following commands:

```bash
pod install
```

If you need another option for managing dependencies (e.g. Carthage), please open an issue to discuss it.

### Project Structure

The entry point for the project is the `Quaderno.xcworkspace` file, which contains two projects:

1. `Quaderno.xcodeproj`, with the source code of the framework.
2. `Pods.xcodeproj`, with third-party dependencies automatically managed by CocoaPods.

### Documentation

The source code is fully documented using the markup formatting commands defined by Apple.


## More Information

Remember that this is only a Swift wrapper for the original API. If you want more information about the API itself, head to the original [API documentation](https://quaderno.io/docs/api/).


## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct, as defined by [contributor-covenant.org](http://contributor-covenant.org/version/1/4/). By participating in this project you agree to abide by its terms.


## Credits

Quaderno has been originally developed by [Eliezer Talón](https://github.com/elitalon).


## Contact

Follow Quaderno ([@quadernoapp](https://twitter.com/quadernoapp)) on Twitter.


## License

Quaderno is released under the MIT license. See [LICENSE.txt](https://github.com/quaderno/quaderno-swift/blob/master/LICENSE.txt).
