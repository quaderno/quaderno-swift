//
// AccountCredentialsTests.swift
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


class AccountCredentialsTests: XCTestCase {

  // MARK: Set Up

  var expectedJSON: ResponseObject!

  override func setUp() {
    super.setUp()
    expectedJSON = [
      "id": 1,
      "name": "John Doe",
      "email": "john.doe@example.com",
      "href": "http://myaccount.quadernoapp.com/api/v1/"
    ]
  }

  // MARK: Examples

  func testThatInitializationFailsWithEmptyJSON() {
    XCTAssertNil(AccountCredentials(jsonDictionary: nil))
  }

  func testThatInitializationFailsWhenIdIsMissing() {
    expectedJSON["id"] = nil
    XCTAssertNil(AccountCredentials(jsonDictionary: expectedJSON))
  }

  func testThatInitializationFailsWhenNameIsMissing() {
    expectedJSON["name"] = nil
    XCTAssertNil(AccountCredentials(jsonDictionary: expectedJSON))
  }

  func testThatInitializationFailsWhenEmailIsMissing() {
    expectedJSON["email"] = nil
    XCTAssertNil(AccountCredentials(jsonDictionary: expectedJSON))
  }

  func testThatInitializationFailsWhenBaseURLIsMissing() {
    expectedJSON["href"] = nil
    XCTAssertNil(AccountCredentials(jsonDictionary: expectedJSON))
  }

  func testThatInitializationSucceedsWhenJSONIsComplete() {
    let credentials = AccountCredentials(jsonDictionary: expectedJSON)
    XCTAssertNotNil(credentials)
    XCTAssertEqual(credentials?.id, 1)
    XCTAssertEqual(credentials?.name, "John Doe")
    XCTAssertEqual(credentials?.email, "john.doe@example.com")
    XCTAssertEqual(credentials?.baseURL, "http://myaccount.quadernoapp.com/api/v1/")
  }

}
