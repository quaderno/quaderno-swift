//
// Client.swift
//
// Copyright (c) 2015-2016 Recrea (http://recreahq.com/)
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


/// Dummy function to provide as default value for optional trailing closures.
func noop<T>(value: T) {}


// MARK: -

/**
 An HTTP client responsible for making requests to a service exposing the
 Quaderno API.
 */
public class Client {

  /// Base URL of the service, typically `https://ACCOUNT-NAME.quadernoapp.com/api/v1/`.
  public let baseURL: String

  /// Token used to authenticate requests to the service.
  public let authenticationToken: String

  /// Default encoding for every request.
  let defaultEncoding = ParameterEncoding.JSON

  /// HTTP headers to authorize every request.
  lazy var authorizationHeaders: [String: String]? = { [unowned self] in
    guard let credentialData = "\(self.authenticationToken):".dataUsingEncoding(NSUTF8StringEncoding) else {
      return nil
    }

    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    return ["Authorization": "Basic \(base64Credentials)"]
  }()

  /**
   Entitlements granted to the current user for using the service.

   If no entitlements are defined, it is not guaranteed that the next request
   will succeed.

   - seealso: [Rate limiting](https://github.com/quaderno/quaderno-api#rate-limiting)
   */
  public private(set) var entitlements: ConnectionEntitlements?

  // MARK: Initialization

  /**
   Initializes a client with a base URL and an authentication token.

   - parameter baseURL: The base URL of the service.
   - parameter authenticationToken: The token used to authenticate request to
   the service.

   - returns: A newly initialized client.

   - seealso: [Authentication](https://github.com/quaderno/quaderno-api#authentication)
   */
  public init(baseURL: String, authenticationToken: String) {
    self.baseURL = baseURL
    self.authenticationToken = authenticationToken
  }

}


// MARK: - Making Requests

extension Client {

  /**
   Checks availability of the service.

   - parameter completion: A closure called when the request finishes.

   - seealso: [Ping the API](https://github.com/quaderno/quaderno-api#ping-the-api).
   */
  public func ping(completion: (success: Bool) -> Void = noop) {
    request(Ping()) { response in
      completion(success: response.isSuccess)
    }
  }

  /**
   Fetches the account details for using the service.

   - parameter completion: A closure called when the request finishes.

   - seealso: [Authorization](https://github.com/quaderno/quaderno-api/blob/master/sections/authentication.md#authorization).
   */
  public func account(completion: (accountCredentials: AccountCredentials?) -> Void = noop) {
    request(Authorization()) { response in
      guard case .Record(let result) = response else {
        completion(accountCredentials: nil)
        return
      }

      let accountCredentials = AccountCredentials(jsonDictionary: result)
      completion(accountCredentials: accountCredentials)
    }
  }

  /**
   Requests a resource.

   - parameter request:    A concrete request to a resource.
   - parameter completion: A closure called when the request finishes. The
   closure has a single parameter that contains the result of the request.

   - seealso:
    - [API resources](https://github.com/quaderno/quaderno-api#api-resources).
    - `Response`.
   */
  public func request(request: Request, completion: (response: Response<NSError>) -> Void = noop) {
    Alamofire.request(request.method, request.uri(baseURL: baseURL), parameters: request.parameters, encoding: .JSON, headers: authorizationHeaders)
      .validate()
      .responseJSON { response in
        self.entitlements = ConnectionEntitlements(httpHeaders: response.response?.allHeaderFields)

        switch response.result {
        case .Success(let value) where value is ResponseObject:
          completion(response: Response.Record(value as! ResponseObject))
        case .Success(let value) where value is [ResponseObject]:
          completion(response: .Collection(value as! [ResponseObject]))
        case .Success(let value) where value is NSNull:
          completion(response: .Empty)
        case .Failure(let error):
          completion(response: .Failure(error))
        default:
          assertionFailure("Unexpected value returned: \(response.result)")
          completion(response: .Empty)
        }
    }
  }

}
