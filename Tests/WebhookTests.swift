//
// WebhookTests.swift
//
// Copyright (c) 2015-2016 Recrea (http://recreahq.com/)
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


class WebhookTests: XCTestCase {

  // MARK: Set Up

  /// Common base URL for all requests
  let baseURL = "https://quadernoapp.com/api/v1/"

  // MARK: CRUD

  func testThatProvidesACreateRequest() {
    let request = Webhook.create([
      "url": "http://anotherapp.com/notifications",
      "events_types": ["invoice.created", "estimate.updated", "invoice.deleted", "contact.created"],
      ])

    XCTAssertEqual(request.method, Method.POST)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/webhooks.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAReadRequest() {
    let request = Webhook.read(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/webhooks/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAListRequest() {
    let request = Webhook.list(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/webhooks.json?page=1")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAnUpdateRequest() {
    let request = Webhook.update(1, attributes: [
      "url": "http://anotherapp.com/notifications",
      "events_types": ["invoice.created", "estimate.updated", "invoice.deleted", "contact.created"],
      ])

    XCTAssertEqual(request.method, Method.PUT)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/webhooks/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesADeleteRequest() {
    let request = Webhook.delete(1)

    XCTAssertEqual(request.method, Method.DELETE)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/webhooks/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

}
