//
// ResponseTests.swift
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

final class ResponseTests: TestCase {

    private let paginationHeaders: [String: String] = [
        Page.HTTPHeader.currentPage.rawValue: "2",
        Page.HTTPHeader.totalPages.rawValue : "5",
    ]

    private func httpResponse(with headers: [String: String]?, statusCode: Int = 200) -> HTTPURLResponse {
        let url = URL(string: "http://example.com")!
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers)!
    }

    // MARK: Pagination

    func testThatPageDoesNotInitializeWhenHTTPHeadersAreEmpty() {
        let response = httpResponse(with: nil)
        XCTAssertNil(Page(httpResponse: response))
    }

    func testThatPageDoesNotInitializeWhenCurrentPageHTTPHeaderIsMissing() {
        var incompleteHeaders = paginationHeaders
        incompleteHeaders.removeValue(forKey: Page.HTTPHeader.currentPage.rawValue)

        let response = httpResponse(with: incompleteHeaders)
        XCTAssertNil(Page(httpResponse: response))
    }

    func testThatPageDoesNotInitializeWhenTotalPagesHTTPHeaderIsMissing() {
        var incompleteHeaders = paginationHeaders
        incompleteHeaders.removeValue(forKey: Page.HTTPHeader.totalPages.rawValue)

        let response = httpResponse(with: incompleteHeaders)
        XCTAssertNil(Page(httpResponse: response))
    }

    func testThatPageDoesNotInitializeWhenCurrentPageHTTPHeaderIsInvalid() {
        var incompleteHeaders = paginationHeaders
        incompleteHeaders[Page.HTTPHeader.currentPage.rawValue] = "a"

        let response = httpResponse(with: incompleteHeaders)
        XCTAssertNil(Page(httpResponse: response))
    }

    func testThatPageDoesNotInitializeWhenTotalPagesHTTPHeaderIsInvalid() {
        var incompleteHeaders = paginationHeaders
        incompleteHeaders[Page.HTTPHeader.totalPages.rawValue] = "a"

        let response = httpResponse(with: incompleteHeaders)
        XCTAssertNil(Page(httpResponse: response))
    }

    func testThatPageInitializesWhenAllHTTPHeaderArePresent() {
        let response = httpResponse(with: paginationHeaders)
        let page = Page(httpResponse: response)
        XCTAssertNotNil(page)
        XCTAssertEqual(page?.number, 2)
        XCTAssertEqual(page?.totalPages, 5)
    }

    // MARK: Response Properties

    func testThatResponseDoesNotHaveValueWhenIsFailure() {
        let fakeError = NSError(domain: "io.quaderno.swift", code: 401, userInfo: nil)
        let response = Response<String>.failure(.serviceError(fakeError))
        XCTAssertNil(response.value)
        XCTAssertNil(response.page)
        XCTAssertNotNil(response.error)
        XCTAssert(response.isError)
    }

    func testThatResponseDoesNotHaveAnErrorWhenIsSuccessful() {
        let response = Response<String>.success("OK", nil)
        XCTAssertNotNil(response.value)
        XCTAssertNil(response.error)
        XCTAssertFalse(response.isError)
    }

    func testThatResponseDoesNotHaveAPageWhenIsSuccessfulWithoutPagination() {
        let response = Response<String>.success("OK", nil)
        XCTAssertNil(response.page)
    }

    func testThatResponseHasAPageWhenIsSuccessfulWithPagination() {
        let response = Response<String>.success("OK", Page(number: 1, totalPages: 1))
        XCTAssertNotNil(response.page)
    }

}
