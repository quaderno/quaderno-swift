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


// MARK: - PaymentData

/**
 The details of a payment.

 - seealso: [Payments](https://github.com/quaderno/quaderno-api/blob/master/sections/payments.md).
 */
public struct PaymentData {

  /**
   Represents the method used to execute a payment.

   - `CreditCard`
   - `Cash`
   - `WireTransfer`
   - `DirectDebit`
   - `Check`
   - `PromissoryNote`
   - `IOU`
   - `PayPal`
   - `Other`
   */
  public enum Method: String {

    case CreditCard = "credit_card"
    case Cash = "cash"
    case WireTransfer = "wire_transfer"
    case DirectDebit = "direct_debit"
    case Check = "check"
    case PromissoryNote = "promissory_note"
    case IOU = "iou"
    case PayPal = "paypal"
    case Other = "other"

  }

  /// The amount to be paid
  let amount: String

  /// The method used to execute the payment.
  let method: Method

}


// MARK: - Payable

/**
 Requirements of a resource that can be paid.

 - seealso: [Payments](https://github.com/quaderno/quaderno-api/blob/master/sections/payments.md).
 */
public protocol Payable {

  associatedtype PayableResource

  /**
   Creates a request for making a payment.

   - parameter documentId: The identifier of a resource associated with the
   payment.
   - parameter details:    The details of the payment.

   - returns: A request for making a payment.
   */
  static func pay(documentId: Int, details: PaymentData) -> Request

  /**
   Creates a request for cancelling a payment.

   - parameter paymentId:  The identifier of a payment.
   - parameter documentId: The identifier of a resource associated with the
   payment.

   - returns: A request for cancelling a payment.
   */
  static func cancelPayment(paymentId: Int, documentId: Int) -> Request

}


// MARK: - PaymentRequest

/**
 A request for paying a resource.

 - seealso:
  - `Request`.
  - `Payable`.
  - `PaymentData`.
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

  /// The details of the payment
  let details: PaymentData?

  // MARK: Request

  var method: HTTPMethod {
    if isPayment {
      return .POST
    } else {
      return .DELETE
    }
  }

  var parameters: RequestParameters? {
    guard let paymentData = details else {
      return nil
    }

    return [
      "amount": paymentData.amount,
      "payment_method": paymentData.method.rawValue
    ]
  }

  func uri(baseURL baseURL: String) -> String {
    if isPayment {
      return (baseURL + R.name + "/\(documentId)/payments").appendJSONSuffix()
    } else {
      precondition(id != nil, "Payment identifier must not be nil")
      return (baseURL + R.name + "/\(documentId)/payments/\(id!)").appendJSONSuffix()
    }
  }

}


// MARK: -

extension Payable where PayableResource: Resource {

  public static func pay(documentId: Int, details: PaymentData) -> Request {
    return PaymentRequest<PayableResource>(documentId: documentId, id: nil, details: details)
  }

  public static func cancelPayment(paymentId: Int, documentId: Int) -> Request {
    return PaymentRequest<PayableResource>(documentId: documentId, id: paymentId, details: nil)
  }

}
