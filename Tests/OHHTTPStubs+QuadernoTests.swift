//
//  OHHTTPStubs+QuadernoTests.swift
//  Quaderno
//
//  Created by Eliezer Talón on 18.03.17.
//  Copyright © 2017 Recrea. All rights reserved.
//

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
