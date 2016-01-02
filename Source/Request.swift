//
// Request.swift
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

import Alamofire


/// Alias for a dictionary representing the parameters sent along with a request.
public typealias RequestParameters = [String: AnyObject]


// MARK: - Request

/**
  Requirements of a request to perform an operation over a resource.
 */
public protocol Request {

  /// The HTTP method to use when requesting a resource
  var method: Alamofire.Method { get }

  /// Parameters to use when requesting a resource.
  var parameters: RequestParameters? { get }

  /**
    Returns a string representing the URI of a resource.

    - parameter baseURL: The base URL of the service.

    - returns: A string representing the URI of a resource.
   */
  func uri(baseURL baseURL: String) -> String

}


// MARK: -

extension String {

  /**
    Returns a string with the suffix `".json"` appended.
   
    - returns: A string with the suffix `".json"` appended.
   */
  func appendJSONSuffix() -> String {
    let jsonExtension = ".json"
    guard !hasSuffix(jsonExtension) else {
      return self
    }
    return self + jsonExtension
  }

}
