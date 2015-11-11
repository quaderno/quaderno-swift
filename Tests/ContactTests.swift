//
// ContactTests.swift
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


class ContactTests: XCTestCase {

  // MARK: Set Up

  /// Common base URL for all requests
  let baseURL = "https://quadernoapp.com/api/v1/"

  // MARK: CRUD

  func testThatProvidesACreateRequest() {
    let request = Contact.create(["first_name": "John"])

    XCTAssertEqual(request.method, Method.POST)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/contacts.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAReadRequest() {
    let request = Contact.read(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAListRequest() {
    let request = Contact.list(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/contacts.json?page=1")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAnUpdateRequest() {
    let request = Contact.update(1, attributes: ["first_name": "John"])

    XCTAssertEqual(request.method, Method.PUT)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesADeleteRequest() {
    let request = Contact.delete(1)

    XCTAssertEqual(request.method, Method.DELETE)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

}
