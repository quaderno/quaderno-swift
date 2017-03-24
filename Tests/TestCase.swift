//
// TestCase.swift
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

import XCTest
import OHHTTPStubs

@testable import Quaderno

/// A base class for all unit tests.
class TestCase: XCTestCase {

    // MARK: Set Up

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    // MARK: Getting a Default Client

    /// The base URL for `httpClient`.
    final let baseURL = URL(string: "https://example.com/api")!

    /// The authentication token for `httpClient`.
    final let authenticationToken = "13e6702df388c6ca96a45ed97b514d96"

    /// A dummy HTTP client configured with `baseURL` and `authenticationToken`.
    final private(set) lazy var httpClient: Client = {
        return Client(baseURL: self.baseURL, authenticationToken: self.authenticationToken)
    }()

    // MARK: Building Common URIs

    /// Returns the URI of a given request using the base URL of `httpClient`.
    ///
    /// - Parameter request: The request to build a URI for.
    /// - Returns: The URI for the request.
    final func uri(for request: Request) -> URL {
        return request.uri(using: httpClient.baseURL)
    }

    /// Returns the URI resulting of appending a given path to the base URL of `httpClient`.
    ///
    /// - Parameter path: The path to append.
    /// - Returns: The URI after appending `path` to the base URL of `httpClient`.
    final func uri(byAppendingPathToBaseURL path: String) -> URL {
        return httpClient.baseURL.appendingPathComponent(path)
    }

    // MARK: Generating Resource Identifiers

    /// Generates a random identifier for a resource.
    ///
    /// - Returns: A random identifier for a resource.
    func generateResourceIdentifier() -> Resource.Identifier {
        return Int(arc4random_uniform(1000)) + 1
    }

    // MARK: Empty Implementation of Requests

    /// A request that adopts the default behaviour of `Request`.
    struct DummyRequest: Request {}

    // MARK: Empty Implementation of Resources

    struct Contact: ContactResource {}

    struct Credit: CreditResource {}

    struct Estimate: EstimateResource {}

    struct Evidence: EvidenceResource {}

    struct Expense: ExpenseResource {}

    struct Invoice: InvoiceResource {}

    struct Item: ItemResource {}

    struct Receipt: ReceiptResource {}

    struct Recurring: RecurringResource {}

    struct Tax: TaxResource {}

    struct Webhook: WebhookResource {}

}
