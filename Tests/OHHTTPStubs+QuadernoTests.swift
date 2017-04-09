//
//  OHHTTPStubs+QuadernoTests.swift
//
// Copyright (c) 2017 Recrea (http://recreahq.com/)
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
import OHHTTPStubs

@testable import Quaderno


// MARK: - Building Common Responses

private typealias HTTPHeader = [String: String]

private let defaultHTTPHeaders: HTTPHeader = [
    "X-RateLimit-Reset"    : "15",
    "X-RateLimit-Remaining": "100",
]

private let defaultPaginationHTTPHeaders: HTTPHeader = {
    var headers = defaultHTTPHeaders
    headers["X-Pages-CurrentPage"] = "2"
    headers["X-Pages-TotalPages"]  = "5"
    return headers
}()

private typealias JSON = [String: Any]

/// Creates a stubbed successful response containing an empty JSON object.
///
/// - Parameter paginated: Whether to include pagination headers.
/// - Returns: A stubbed successful response containing an empty JSON object.
func successJSONResponse(paginated: Bool = false) -> OHHTTPStubsResponse {
    let headers: HTTPHeader = (paginated ? defaultPaginationHTTPHeaders : defaultHTTPHeaders)
    return OHHTTPStubsResponse(jsonObject: JSON(), statusCode: 200, headers: headers)
}

/// A stubbed HTTP 401 response containing an empty JSON object.
let unauthorizedJSONResponse: OHHTTPStubsResponse = {
    return OHHTTPStubsResponse(jsonObject: JSON(), statusCode: 401, headers: defaultHTTPHeaders)
}()


// MARK: - Stubbing Requests

private func isMethod(_ method: Quaderno.HTTPMethod) -> OHHTTPStubsTestBlock {
    return { $0.httpMethod == method.rawValue }
}

private func matchesURL(_ url: URL) -> OHHTTPStubsTestBlock {
    return { $0.url == url }
}

/// Stubs a request using a base URL and returning a given response.
///
/// - Parameters:
///   - request: The request to stub.
///   - client: The client sending the request.
///   - sucess: Whether the request is successful or not (defaults to `true`).
///   - response: The response to stub (defaults to `successJSONResponse()`).
func stub(_ request: Quaderno.Request, using httpClient: Client, succeeding sucess: Bool = true, with response: OHHTTPStubsResponse = successJSONResponse()) {
    stub(condition: isMethod(request.method) && matchesURL(request.uri(using: httpClient.baseURL))) { _ in return response }
}
