//
// TaxTests.swift
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


class TaxTests: XCTestCase {

  func testThatCalculatingTaxesReturnsAValidRequest() {
    let request = Tax.calculate(country: "ES")

    XCTAssertEqual(request.method, Alamofire.Method.GET)
    XCTAssertNotNil(request.parameters)

    let baseURL = "https://quadernoapp.com/api/v1/"
    let uri = request.uri(baseURL: baseURL)
    XCTAssertEqual(uri, "https://quadernoapp.com/api/v1/taxes/calculate.json")
    XCTAssertNotNil(NSURL(string: uri))
  }

  func testThatDefaultValuesForCalculatingTaxesAreValid() {
    let request = Tax.calculate(country: "ES")

    guard let parameters = request.parameters else {
      XCTFail("Unexpected nil parameters for request")
      return
    }

    XCTAssertEqual(parameters["country"] as? String, "ES")
    XCTAssertNil(parameters["postal_code"])
    XCTAssertNil(parameters["vat_number"])
    XCTAssertEqual(parameters["transaction_type"] as? String, Tax.Transaction.Service.rawValue)
  }

  func testThatGivenParametersForCalculatingTaxesAreHonoured() {
    let request = Tax.calculate(country: "ES", transactionType: .Standard, postalCode: "1234", vatNumber: "4321")

    guard let parameters = request.parameters else {
      XCTFail("Unexpected nil parameters for request")
      return
    }

    XCTAssertEqual(parameters["country"] as? String, "ES")
    XCTAssertEqual(parameters["postal_code"] as? String, "1234")
    XCTAssertEqual(parameters["vat_number"] as? String, "4321")
    XCTAssertEqual(parameters["transaction_type"] as? String, Tax.Transaction.Standard.rawValue)
  }

}
