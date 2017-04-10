//
// Request.swift
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

/// The parameters of an HTTP request.
public typealias HTTPParameters = [String: Any]

/// A type representing an HTTP request that performs an operation on a resource.
public protocol Request {

    /// The HTTP method (defaults to `.get`).
    var method: HTTPMethod { get }

    /// The parameters (defaults to `nil`).
    var parameters: HTTPParameters? { get }

    /// Build the URI of a resource using a base URL.
    ///
    /// The default implementation returns the base URL without any further modification.
    ///
    /// - Parameter baseURL: The base URL of the URI.
    /// - Returns: The URI of a resource.
    func uri(using baseURL: URL) -> URL

}

public extension Request {

    var method: HTTPMethod {
        return .get
    }

    var parameters: HTTPParameters? {
        return nil
    }

    func uri(using baseURL: URL) -> URL {
        return baseURL
    }

}

extension URL {

    var toJSON: URL {
        return appendingPathExtension("json")
    }

}


// MARK: -

/// HTTP methods available for sending requests.
public enum HTTPMethod: String {

    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"

}
