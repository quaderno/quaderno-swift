//
// PaymentDataTests.swift
//
// Copyright (c) 2016 Recrea (http://recreahq.com/)
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

/**
 Experimental function to generate all cases in an enumeration. This might break
 in the future.
 */
func iterateEnum<T: Hashable>(_: T.Type) -> AnyGenerator<T> {
  var i = 0
  return AnyGenerator {
    defer {
      i += 1
    }
    let next = withUnsafePointer(&i) { UnsafePointer<T>($0).memory }
    return next.hashValue == i ? next : nil
  }
}

class PaymentDataTests: XCTestCase {

  func testThatProvidesPaymentMethods() {
    for paymentMethod in iterateEnum(PaymentData.Method.self) {
      switch paymentMethod {
      case .CreditCard:
        XCTAssertEqual(paymentMethod.rawValue, "credit_card")
      case .Cash:
        XCTAssertEqual(paymentMethod.rawValue, "cash")
      case .WireTransfer:
        XCTAssertEqual(paymentMethod.rawValue, "wire_transfer")
      case .DirectDebit:
        XCTAssertEqual(paymentMethod.rawValue, "direct_debit")
      case .Check:
        XCTAssertEqual(paymentMethod.rawValue, "check")
      case .PromissoryNote:
        XCTAssertEqual(paymentMethod.rawValue, "promissory_note")
      case .IOU:
        XCTAssertEqual(paymentMethod.rawValue, "iou")
      case .PayPal:
        XCTAssertEqual(paymentMethod.rawValue, "paypal")
      case .Other:
        XCTAssertEqual(paymentMethod.rawValue, "other")
      }
    }
  }

  func testThatRequestParametersMatches() {
    let paymentDetails = PaymentData(amount: "12.34", method: .DirectDebit)
    let paymentRequest = PaymentRequest<Invoice>(documentId: 1, id: nil, details: paymentDetails)

    XCTAssertEqual(paymentRequest.parameters?["amount"] as? String, "12.34")
    XCTAssertEqual(paymentRequest.parameters?["payment_method"] as? String, "direct_debit")
  }

}
