//
//  QuadernoTests.swift
//
//  Copyright (c) 2013-2015 Recrea (http://recreahq.com/)
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

import XCTest
import OHHTTPStubs


class QuadernoTests: XCTestCase {

  // MARK: Test Subject

  var httpClient: Client!

  // MARK: Set Up

  override func setUp() {
    super.setUp()

    if let baseURL = NSURL(string: "https://quadernoapp.com/api/v1/") {
      httpClient = Client(baseURL: baseURL, authenticationToken: "My token")
    }
  }

  override func tearDown() {
    httpClient = nil
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  // MARK: Ping

  func testThatPingCompletesWithSuccessWhenConnectionIsAvailable() {
    OHHTTPStubs.stubRequestsPassingTest({ request in
      request.HTTPMethod == "GET" && request.URL!.lastPathComponent == PingResource.path
      }) { _ in
        return OHHTTPStubsResponse(JSONObject: ["status": "OK"], statusCode: 200, headers: nil)
    }

    let expectation = expectationWithDescription("ping finishes")
    httpClient.ping { success in
      if success {
        expectation.fulfill()
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatPingCompletesWithoutSuccessWhenConnectionIsUnavailable() {
    OHHTTPStubs.stubRequestsPassingTest({ request in
      request.HTTPMethod == "GET" && request.URL!.lastPathComponent == PingResource.path
      }) { _ in
        return OHHTTPStubsResponse(JSONObject: ["error": "Not authorized"], statusCode: 401, headers: nil)
    }

    let expectation = expectationWithDescription("ping finishes")
    httpClient.ping { success in
      if !success {
        expectation.fulfill()
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

}
