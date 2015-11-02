//
// Client.swift
//
// Copyright (c) 2015 Recrea (http://recreahq.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Alamofire

// MARK: Helper Functions

/// Dummy function to provide as default value for optional trailing closures.
func noop<T>(value: T) {}


// MARK:-

/**
 An HTTP client responsible for making requests to a service exposing the Quaderno API.
 */
public class Client {

  // MARK: Properties

  /// The base URL of the service, typically `https://ACCOUNT-NAME.quadernoapp.com/api/v1/`.
  public let baseURL: String

  /// The token used to authenticate requests to the service.
  public let authenticationToken: String

  /**
    The entitlements granted to the current user for using the service.

    If no entitlements are defined, it is not guaranteed that the next request will succeed.

    - seealso: [Rate limiting](https://github.com/quaderno/quaderno-api#rate-limiting)
   */
  public private(set) var entitlements: ConnectionEntitlements?

  // MARK: Initialization

  /**
    Initializes a client with a base URL and an authentication token.
  
    - parameter baseURL: The base URL of the service.
    - parameter authenticationToken: The token used to authenticate request to the service.

    - returns: A newly initialized client.

    - seealso: [Authentication](https://github.com/quaderno/quaderno-api#authentication)
   */
  public init(baseURL: String, authenticationToken: String) {
    self.baseURL = baseURL
    self.authenticationToken = authenticationToken
  }

  // MARK: Checking Service Availability

  /**
    Checks availability of the service.

    - parameter completion: A closure called when the request finishes.

    - seealso: [Ping the API](https://github.com/quaderno/quaderno-api#ping-the-api).
   */
  public func ping(completion: (success: Bool) -> Void = noop) {
    Alamofire.request(.GET, PingResource(baseURLString: baseURL))
      .authenticate(user: authenticationToken, password: "")
      .validate()
      .responseJSON { response in
        switch response.result {
        case .Success:
          completion(success: true)
        case .Failure:
          completion(success: false)
        }
    }
  }

  /**
    Fetches the connection entitlements for using the service with the current account.

    - parameter completion: A closure called when the request finishes.

    - postcondition: The value of `entitlements` is updated when the request finishes.

    - seealso: [Rate limiting](https://github.com/quaderno/quaderno-api#rate-limiting).
   */
  public func fetchConnectionEntitlements(completion: (entitlements: ConnectionEntitlements?) -> Void = noop) {
    Alamofire.request(.GET, PingResource(baseURLString: baseURL))
      .authenticate(user: authenticationToken, password: "")
      .validate()
      .responseJSON { response in
        self.entitlements = ConnectionEntitlements(httpHeaders: response.response?.allHeaderFields)
        completion(entitlements: self.entitlements)
    }
  }

}
