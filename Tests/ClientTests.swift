//
// ClientTests.swift
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

import XCTest

@testable import Quaderno

final class ClientTests: TestCase {

    typealias EntitlementsHTTPHeader = Client.Entitlements.HTTPHeader

    // MARK: Initialization

    func testThatBuildsAuthorizationHeaders() {
        XCTAssertFalse(httpClient.authorizationHeaders["Authorization"]!.isEmpty)
    }

    // MARK: Entitlements

    func testThatEntitlementsDoesNotInitializeWhenHTTPHeadersAreEmpty() {
        let entitlements = Client.Entitlements(httpHeaders: [:])
        XCTAssertNil(entitlements)
    }

    func testThatEntitlementsDoesNotInitializeWhenRateLimitHTTPHeadersAreIncomplete() {
        var incompleteHeaders = [String: Any]()

        incompleteHeaders[EntitlementsHTTPHeader.rateLimitReset.rawValue] = "100"
        XCTAssertNil(Client.Entitlements(httpHeaders: incompleteHeaders))

        incompleteHeaders[EntitlementsHTTPHeader.rateLimitReset.rawValue] = nil
        incompleteHeaders[EntitlementsHTTPHeader.rateLimitRemainingRequests.rawValue] = "100"
        XCTAssertNil(Client.Entitlements(httpHeaders: incompleteHeaders))
    }

    func testThatEntitlementsDoesNotInitializeWhenRateLimitHTTPHeadersAreInvalid() {
        var invalidHeaders = [String: Any]()

        invalidHeaders[EntitlementsHTTPHeader.rateLimitRemainingRequests.rawValue] = "100"

        invalidHeaders[EntitlementsHTTPHeader.rateLimitReset.rawValue] = Data()
        XCTAssertNil(Client.Entitlements(httpHeaders: invalidHeaders))

        invalidHeaders[EntitlementsHTTPHeader.rateLimitReset.rawValue] = "NonNumeric"
        XCTAssertNil(Client.Entitlements(httpHeaders: invalidHeaders))

        invalidHeaders[EntitlementsHTTPHeader.rateLimitReset.rawValue] = "100"

        invalidHeaders[EntitlementsHTTPHeader.rateLimitRemainingRequests.rawValue] = Data()
        XCTAssertNil(Client.Entitlements(httpHeaders: invalidHeaders))

        invalidHeaders[EntitlementsHTTPHeader.rateLimitRemainingRequests.rawValue] = "NonNumeric"
        XCTAssertNil(Client.Entitlements(httpHeaders: invalidHeaders))
    }

    func testThatEntitlementsInitializesWhenAllHTTPHeaderArePresent() {
        let httpHeaders: [String: Any] = [
            EntitlementsHTTPHeader.rateLimitReset.rawValue: "15",
            EntitlementsHTTPHeader.rateLimitRemainingRequests.rawValue: "100",
        ]
        let entitlements = Client.Entitlements(httpHeaders: httpHeaders)
        XCTAssertNotNil(entitlements)
        XCTAssertEqual(entitlements?.resetInterval, 15)
        XCTAssertEqual(entitlements?.remainingRequests, 100)
    }

    // MARK: Processing Response Metadata

    func testThatEntitlementsIsNilBeforeSendingAnyRequest() {
        XCTAssertNil(httpClient.entitlements)
    }

    func testThatUpdatesEntitlementsWhenSendingRequests() {
        let request = DummyRequest()
        stub(request, using: httpClient)
        XCTAssertNil(httpClient.entitlements)

        let expectation = self.expectation(description: "request finishes")
        httpClient.send(request) { error in
            XCTAssertNil(error)
            XCTAssertNotNil(self.httpClient.entitlements)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testThatBuildsPageWhenPaginationIsActive() {
        let request = DummyRequest()
        stub(request, using: httpClient, succeeding: true, with: successJSONResponse(paginated: true))

        let expectation = self.expectation(description: "request finishes")
        httpClient.send(request) { (result: Response<[String: Any]>) in
            XCTAssertFalse(result.isError)
            XCTAssertNotNil(result.page)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testThatDoesNotBuildPageWhenPaginationIsNotActive() {
        let request = DummyRequest()
        stub(request, using: httpClient)

        let expectation = self.expectation(description: "request finishes")
        httpClient.send(request) { (result: Response<[String: Any]>) in
            XCTAssertFalse(result.isError)
            XCTAssertNil(result.page)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: Ping

    func testThatPingRequestBuildsURL() {
        let url = Client.PingRequest().uri(using: httpClient.baseURL)
        XCTAssertEqual(url.absoluteString, "\(httpClient.baseURL.absoluteString)/ping.json")
    }

    func testThatPingReturnsSuccessWhenConnectionIsAllowed() {
        let pingRequest = Client.PingRequest()
        stub(pingRequest, using: httpClient)

        let expectation = self.expectation(description: "request finishes")
        httpClient.ping { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testThatPingReturnsFailureWhenConnectionIsAllowed() {
        let pingRequest = Client.PingRequest()
        stub(pingRequest, using: httpClient, succeeding: false, with: unauthorizedJSONResponse)

        let expectation = self.expectation(description: "request finishes")
        httpClient.ping { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: Authorization

    func testThatAuthorizationRequestBuildsURL() {
        let url = Client.AuthorizationRequest().uri(using: httpClient.baseURL)
        XCTAssertEqual(url.absoluteString, "https://quadernoapp.com/api/authorization.json")
    }

    func testThatAuthorizationReturnsSuccessWhenConnectionIsAllowed() {
        let authorizationRequest = Client.AuthorizationRequest()
        stub(authorizationRequest, using: httpClient)

        let expectation = self.expectation(description: "request finishes")
        httpClient.account { result in
            XCTAssertFalse(result.isError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testThatAuthorizationReturnsFailureWhenConnectionIsAllowed() {
        let authorizationRequest = Client.AuthorizationRequest()
        stub(authorizationRequest, using: httpClient, succeeding: false, with: unauthorizedJSONResponse)

        let expectation = self.expectation(description: "request finishes")
        httpClient.account { result in
            XCTAssert(result.isError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

}
