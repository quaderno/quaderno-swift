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

@testable import Quaderno

import XCTest
import OHHTTPStubs


class ClientTests: XCTestCase {

  // MARK: Test Subject

  var httpClient: Client!

  // MARK: Set Up

  override func setUp() {
    super.setUp()
    httpClient = Client(baseURL: "https://example.com/api/v2/", authenticationToken: "My token")
  }

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  // MARK: Ping

  func testThatPingCompletesWithSuccessWhenConnectionIsAvailable() {
    OHHTTPStubs.stubPingRequest(success: true)

    let expectation = expectationWithDescription("ping finishes")
    httpClient.ping { success in
      if success {
        expectation.fulfill()
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatPingCompletesWithoutSuccessWhenConnectionIsUnavailable() {
    OHHTTPStubs.stubPingRequest(success: false)

    let expectation = expectationWithDescription("ping finishes")
    httpClient.ping { success in
      if !success {
        expectation.fulfill()
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  // MARK: Connection Entitlements

  func testThatFetchingConnectionEntitlementsReturnsNilWhenHeadersAreInvalid() {
    let response = OHHTTPStubsResponse(JSONObject: [], statusCode: 200, headers: nil)
    OHHTTPStubs.stubPingRequest(success: true, response: response)

    let expectation = expectationWithDescription("ping finishes")
    httpClient.fetchConnectionEntitlements { entitlements in
      XCTAssertNil(entitlements)
      XCTAssertNil(self.httpClient.entitlements)
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatFetchingConnectionEntitlementsReturnsEntitlementsWhenHeadersAreValid() {
    OHHTTPStubs.stubPingRequest(success: true)

    let expectation = expectationWithDescription("ping finishes")
    httpClient.fetchConnectionEntitlements { entitlements in
      XCTAssertNotNil(entitlements)
      XCTAssertNotNil(self.httpClient.entitlements)
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  // MARK: Account Credentials

  func testThatFetchingAccountCredentialsReturnsNilWhenJSONIsInvalid() {
    let response = OHHTTPStubsResponse(JSONObject: [], statusCode: 200, headers: nil)
    OHHTTPStubs.stubAuthorizationRequest(success: true, response: response)

    let expectation = expectationWithDescription("authorization finishes")
    httpClient.fetchAccountCredentials { credentials in
      XCTAssertNil(credentials)
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatFetchingAccountCredentialsReturnsCredentialsWhenJSONIsValid() {
    OHHTTPStubs.stubAuthorizationRequest(success: true)

    let expectation = expectationWithDescription("authorization finishes")
    httpClient.fetchAccountCredentials { credentials in
      XCTAssertNotNil(credentials)
      expectation.fulfill()
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  // MARK: Requesting Resources

  func testThatCreatingResourcesReturnsTheCreatedRecordWhenSucceeds() {
    OHHTTPStubs.stubCreateContactRequest(success: true)

    let expectation = expectationWithDescription("creating a contact finishes")
    let resource = Contact.create(["first_name": "John"])
    httpClient.request(resource) { response in
      XCTAssert(response.isSuccess)
      switch response{
      case .Record:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when creating a resource")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatReadingResourcesReturnsTheRecordWhenSucceeds() {
    OHHTTPStubs.stubReadContactRequest(success: true)

    let expectation = expectationWithDescription("reading a contact finishes")
    let resource = Contact.read(1)
    httpClient.request(resource) { response in
      XCTAssert(response.isSuccess)
      switch response{
      case .Record:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when reading a resource")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatListingResourcesReturnsAnArrayOfRecordsWhenSucceeds() {
    OHHTTPStubs.stubListContactRequest(success: true)

    let expectation = expectationWithDescription("listing contacts finishes")
    let resource = Contact.list(1)
    httpClient.request(resource) { response in
      XCTAssert(response.isSuccess)
      switch response{
      case .Collection:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when listing resources")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatUpdatingResourcesReturnsTheRecordWhenSucceeds() {
    OHHTTPStubs.stubUpdateContactRequest(success: true)

    let expectation = expectationWithDescription("updating a contact finishes")
    let resource = Contact.update(1, attributes: ["first_name": "John"])
    httpClient.request(resource) { response in
      XCTAssert(response.isSuccess)
      switch response{
      case .Record:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when updating a resource")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatDeletingResourcesReturnsEmptyWhenSucceeds() {
    OHHTTPStubs.stubDeleteContactRequest(success: true)

    let expectation = expectationWithDescription("deleting a contact finishes")
    let resource = Contact.delete(1)
    httpClient.request(resource) { response in
      XCTAssert(response.isSuccess)
      switch response{
      case .Empty:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when deleting a resource")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testThatRequestingResourcesReturnsErrorWhenFails() {
    OHHTTPStubs.stubDeleteContactRequest(success: false)

    let expectation = expectationWithDescription("deleting a contact finishes")
    let resource = Contact.delete(1)
    httpClient.request(resource) { response in
      XCTAssert(response.isFailure)
      switch response{
      case .Failure:
        expectation.fulfill()
      default:
        XCTFail("Unexpected response when deleting a resource")
      }
    }
    waitForExpectationsWithTimeout(1, handler: nil)
  }

}
