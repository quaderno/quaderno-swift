//
// PingTests.swift
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
import Alamofire


class PingTests: XCTestCase {

  // MARK: Test subject

  var resource: Ping!

  // MARK: Set Up

  override func setUp() {
    super.setUp()
    resource = Ping()
  }

  // MARK: Examples

  func testThatContentTypeExtensionIsJSON() {
    XCTAssertEqual(resource.contentTypeExtension, ".json")
  }

  func testThatURIStringIsValid() {
    let baseURLString = "https://quadernoapp.com/api/v1/"
    let uriString = resource.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/ping.json")
    XCTAssertNotNil(NSURL(string: uriString))
  }

  func testThatProvidesTheExpectedName() {
    XCTAssertEqual(resource.name, "ping")
  }

  func testThatProvidesTheExpectedPath() {
    XCTAssertEqual(resource.path, "ping.json")
  }

  func testThatProvidesTheExpectedMethod() {
    XCTAssertEqual(resource.method, Alamofire.Method.GET)
  }

  func testThatProvidesTheExpectedParameters() {
    XCTAssertNil(resource.parameters)
  }

}
