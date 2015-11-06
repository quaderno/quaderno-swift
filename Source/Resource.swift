//
// Resource.swift
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

import Alamofire

/// Alias for a dictionary containing parameters to send when requesting a resource.
public typealias Record = [String: AnyObject]


// MARK: Resource

/**
  Requirements of a resource.
 */
public protocol Resource {

  /**
    The extension of a resource's URI (e.g. `".json"`, `".xml"`,...).

    The default value is `".json"`.
   */
  var contentTypeExtension: String { get }

  /// Name of the service end point that exposes a resource (e.g. `"contacts"`).
  var name: String { get }

  /// Method used to request a resource.
  var method: Alamofire.Method { get }

  /**
    Relative path of a resource.

    This value is appended to a base URL to generate a URI for a resource.

    - seealso: `URIString(baseURLString:)`
   */
  var path: String { get }

  /// Parameters to send when requesting a resource.
  var parameters: Record? { get }

  /**
    Returns a string containing the URI that represents the resource to request.

    The default implementation generates an URI by appending `path` to `baseURLString`.

    - parameter baseURLString: The base URL of the service.

    - returns: A string containing the URI that represents a resource.
   */
  func URIString(baseURLString baseURLString: String) -> String

}


public extension Resource {

  var contentTypeExtension: String {
    return ".json"
  }

  func URIString(baseURLString baseURLString: String) -> String {
    return baseURLString + path
  }

}
