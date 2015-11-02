//
// OHHTTPStubs+Quaderno.swift
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

@testable import Quaderno

import OHHTTPStubs


// MARK:- Response

/// Alias to define a JSON response
typealias JSONResponse = [String: AnyObject]

/**
  Properties of a response returned after requesting a resource.
 */
protocol Response {

  /// The HTTP code returned when requesting the resource succeeds.
  static var successCode: Int { get }

  /// A stubbed JSON object returned when requesting the resource succeeds.
  static var successJSON: JSONResponse { get }

  /// The HTTP code returned when requesting the resource fails.
  static var failureCode: Int { get }

  /// A stubbed JSON object returned when requesting the resource fails.
  static var failureJSON: JSONResponse { get }

  /// The HTTP headers returned with every response.
  static var httpHeaders: HTTPHeaders? { get }

}

/**
  Provides the default values returned in a response.
 */
extension Response {

  static var successCode: Int {
    return 200
  }

  static var successJSON: JSONResponse {
    return [
      "status": "OK",
    ]
  }

  static var failureCode: Int {
    return 400
  }

  static var failureJSON: JSONResponse {
    return [
      "error": "An error has occurred",
    ]
  }

  static var httpHeaders: HTTPHeaders? {
    return [
      ConnectionEntitlements.HTTPHeader.Reset.rawValue: "15",
      ConnectionEntitlements.HTTPHeader.Remaining.rawValue: "100",
    ]
  }

}


// MARK:- Common Responses

/// A stubbed default response for `PingResource`.
struct PingResponse: Response {}


// MARK:-

extension OHHTTPStubs {

  /**
    Available HTTP methods
   */
  enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
  }

  // MARK: Helper Functions

  /**
    Returns whether a given request matches given method and path.

    - parameter request:    A request to query using method and path.
    - parameter httpMethod: An HTTP method to query the request with.
    - parameter path:       A relative path to query the request with.

    - returns: Whether the request uses the given method and contains the given path.
   */
  final class func requestMatches(request: NSURLRequest, httpMethod method: HTTPMethod, path: String) -> Bool {
    return (request.HTTPMethod == method.rawValue && request.URL!.lastPathComponent == path)
  }

  // MARK: Common Stubs

  /**
    Stubs a request to `PingResource`.

    - parameter success: Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response that overrides the default one (`PingResponse`).

    - seealso: `PingResponse`
   */
  final class func stubPingRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    stubRequestsPassingTest({ request in return requestMatches(request, httpMethod: .GET, path: PingResource.path) }) { _ in
      if let stubbedResponse = response {
        return stubbedResponse
      }

      let JSONResponse = (success ? PingResponse.successJSON : PingResponse.failureJSON)
      let statusCode = (success ? PingResponse.successCode : PingResponse.failureCode)
      return OHHTTPStubsResponse(JSONObject: JSONResponse, statusCode: CInt(statusCode), headers: PingResponse.httpHeaders)
    }
  }

}
