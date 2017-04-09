# Change Log
All notable changes to this project will be documented in this file. `Quaderno` adheres to [Semantic Versioning](http://semver.org/).

#### 0.x Releases
- `0.0.x` Releases - [0.0.1](#001) | [0.0.2](#002)
- `0.x.x` Releases - [0.1.0](#010) | [0.2.0](#020) | [0.3.0](#030) | [0.4.0](#040) | [0.5.0](#050) | [0.6.0](#060)
- `1.x.x` Releases - [1.0.0](#100)
- `2.x.x` Releases - [2.0.0](#200)

---

## [2.0.0](https://github.com/quaderno/quaderno-swift/releases/tag/2.0.0)

Unreleased.

#### Changed

- Resource structs (e.g. `Contact`) have been replaced by protocols (e.g. `ContactResource`).
- `ConnectionEntitlements` has been replaced by `Client.Entitlements`.
- `Request` works now with Foundation's `URL` instead of `String`.
- `Response` now handles generic responses, instead of only records and collection of records.
- Dependencies are now managed with Carthage instead of CocoaPods.

#### Added

- `Response` supports now pagination, which is automatically parsed by `Client` whenever a request finishes.
- `Response` supports now concrete error types through `ErrorResponse`.
- Partial support for `Evidences` (see limitations in Quaderno's API documentation).
- Support for macOS platform.

#### Removed

- `AccountCredentials` has been removed. Use the JSON response of the request instead.

#### Fixed

- Support for Swift 3.
- `PayableResource` now support all available operations.


## [1.0.0](https://github.com/quaderno/quaderno-swift/releases/tag/1.0.0)

Released on 2016-01-04.

#### Changed

- `Authorization` and `Ping` have been made `internal`, as they do not need to be `public`.
- Explicit parameters for making payments and calculating taxes have been replaced with types:
  - `PaymentData`.
  - `TransactionDetails`.
- `Transaction` has been renamed to `TransactionType`.

#### Removed

- Encoding of requests are no longer customisable. We use `JSON` everywhere.


## [0.6.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.6.0)

Unreleased.

#### Added

- A `Payable` protocol for those resource that can be paid:
  - `Expense`
  - `Invoice`

#### Changed

- `fetchAccountCredentials` has been renamed to `account`.

#### Removed

- `fetchConnectionEntitlements` has been removed. The `entitlements` property in `Ciient` is now updated after completing every request.


## [0.5.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.5.0)

Unreleased.

#### Added

- A `Tax` resource for calculating taxes.


## [0.4.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.4.0)

Unreleased.

#### Added

- An `Authorization` resource for fetching account credentials.
- A `fetchAccountCredentials()` function in `Client`.


## [0.3.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.3.0)

Unreleased.

#### Added

- A `Deliverable` protocol for those resources that support delivery operations:
  - `Estimate`.
  - `Credit`.
  - `Invoice`.

#### Changed

- Resources are now implemented as struct instead of classes.

#### Fixed

- Access control for resources. Some previously declared as internal are now public.


## [0.2.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.2.0)

Unreleased.

#### Added

- The remaining resources in Quaderno that supports CRUD operations:
  - `Webhook`.
  - `Recurring`.
  - `Expense`.
  - `Estimate`.
  - `Credit`.
  - `Invoice`.
  - `Item`.

#### Removed

- Included HTML documentation. We rely now in the documentation generated automatically by [CocoaDocs](http://cocoadocs.org).


## [0.1.0](https://github.com/quaderno/quaderno-swift/releases/tag/0.1.0)

Unreleased.

#### Added

- A function in `Client` to request resources.
- The following protocols:
  - `Resource``: representing a resource in the API.
  - `Request`: defining how to request a particular resource.
  - `Response`: representing the responses returned by the service when a request finishes.
- Two behaviours, based on the above protocols:
  - `CRUD`: providing a default implementation for creating CRUD requests.
  - `SingleRequest`: for resources implementing a single request.
- A `Contact` resource adhering to the `CRUD` protocol.

#### Changed

- `Ping` has been rewritten using the new interfaces.


## [0.0.2](https://github.com/quaderno/quaderno-swift/releases/tag/0.0.2)

Released on 2015-11-02. All issues associated with this release can be found in the [library-modernisation milestone](https://github.com/elitalon/quaderno-swift/milestones/library-modernisation).

#### Removed

- The `RECQuadernoClient` class.
- All previous Objective-C code.

#### Fixed

- Support for installing the framework using [Cocoapods](https://cocoapods.org).

#### Added

- A YAML file to add support for continuous integration using [Travis CI](https://travis-ci.org).
- A `Client` class, replacing the previous `RECQuadernoClient` class with the same functionality.

#### Changed

- The project name, from `QuadernoKit` to `Quaderno`.
- The networking library. [Alamofire](https://github.com/Alamofire/Alamofire) replaces [AFNetworking](https://github.com/AFNetworking/AFNetworking).
- Rules for ignoring files in Git.
- The COPYRIGHT in all files with the latest date.
- The README to include the new project structure.
- The documentation is now generated with [jazzy](https://github.com/realm/jazzy) instead of `appledoc`.


## [0.0.1](https://github.com/quaderno/quaderno-swift/releases/tag/0.0.1)

Released on 2013-11-10.

#### Added

- A `RECQuadernoClient` class, supporting [ping](https://github.com/quaderno/quaderno-api#ping-the-api) and [rate limit](https://github.com/quaderno/quaderno-api#rate-limiting).
