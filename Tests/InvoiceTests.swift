//
// InvoiceTests.swift
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


class InvoiceTests: XCTestCase {

  // MARK: Set Up

  /// Common base URL for all requests
  let baseURL = "https://quadernoapp.com/api/v1/"

  // MARK: CRUD

  func testThatProvidesACreateRequest() {
    let request = Invoice.create([
      "contact_id": "1",
      "items_attributes":[
        ["reference": "BluRay 0003", "quantity": "2", "unit_cost": "10.95"],
      ],
      ])

    XCTAssertEqual(request.method, Method.POST)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAReadRequest() {
    let request = Invoice.read(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAListRequest() {
    let request = Invoice.list(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices.json?page=1")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesAnUpdateRequest() {
    let request = Invoice.update(1, attributes: [
      "contact_id": "1",
      "items_attributes":[
        ["reference": "BluRay 0003", "quantity": "2", "unit_cost": "10.95"],
      ],
      ])

    XCTAssertEqual(request.method, Method.PUT)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatProvidesADeleteRequest() {
    let request = Invoice.delete(1)

    XCTAssertEqual(request.method, Method.DELETE)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  // MARK: Deliverable

  func testThatProvidesADeliverRequest() {
    let request = Invoice.deliver(1)

    XCTAssertEqual(request.method, Method.GET)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/1/deliver.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  // MARK: Payable

  func testThatCanBePaid() {
    let request = Invoice.pay(1, details: ["amount": "56.60", "payment_method": "credit_card"])

    XCTAssertEqual(request.method, Method.POST)
    XCTAssertNotNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/1/payments.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatCanCancelPayments() {
    let request = Invoice.cancelPayment(1, documentId: 2)

    XCTAssertEqual(request.method, Method.DELETE)
    XCTAssertNil(request.parameters)

    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/invoices/2/payments/1.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

}
