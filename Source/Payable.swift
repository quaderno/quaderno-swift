//
// Payable.swift
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

import Alamofire


// MARK: - Payable

/**
  Requirements of a resource that can be paid.
  
  - seealso:
    - `Resource`.
    - [Payments](https://github.com/quaderno/quaderno-api/blob/master/sections/payments.md).
 */
public protocol Payable {

  typealias PayableResource

  /**
    Creates a request for making a payment.

    - parameter documentId: The identifier of a resource associated with the payment.
    - parameter details:    The details of the payment.

    - returns: A request for making a payment.
   */
  static func pay(documentId: Int, details: RequestParameters) -> Request

  /**
    Creates a request for cancelling a payment.

    - parameter paymentId:  The identifier of a payment.
    - parameter documentId: The identifier of a resource associated with the payment.

    - returns: A request for cancelling a payment.
   */
  static func cancelPayment(paymentId: Int, documentId: Int) -> Request

}


// MARK:-

/**
  A struct to represent a request for paying a resource.

  - seealso:
    - `Resource`.
    - `Payable`.
 */
struct PaymentRequest<R: Resource>: Request {

  /// The identifier of a document associated with a payment
  let documentId: Int

  /// The identifier of a payment.
  let id: Int?

  /// Whether the request represents a payment to be made.
  var isPayment: Bool {
    return id == nil && parameters != nil
  }

  // MARK: Request

  var method: Alamofire.Method {
    if isPayment {
      return .POST
    } else {
      return .DELETE
    }
  }

  let parameters: RequestParameters?

  func uri(baseURL baseURL: String) -> String {
    if isPayment {
      return (baseURL + R.name + "/\(documentId)/payments").appendJSONSuffix()
    } else {
      precondition(id != nil, "Payment identifier must not be nil")
      return (baseURL + R.name + "/\(documentId)/payments/\(id!)").appendJSONSuffix()
    }
  }

}


extension Payable where PayableResource: Resource {

  public static func pay(documentId: Int, details: RequestParameters) -> Request {
    return PaymentRequest<PayableResource>(documentId: documentId, id: nil, parameters: details)
  }

  public static func cancelPayment(paymentId: Int, documentId: Int) -> Request {
    return PaymentRequest<PayableResource>(documentId: documentId, id: paymentId, parameters: nil)
  }

}
