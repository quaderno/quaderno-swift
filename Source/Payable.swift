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
  
  - seealso: `Resource`.
 */
public protocol Payable {

  typealias PayableResource

  /**
    Creates a request for paying a resource.

    - parameter id:      The identifier of a resource.
    - parameter details: The details of the payment.

    - returns: A request for paying a resource.
   */
  static func pay(id: Int, details: RequestParameters) -> Request

}


// MARK:-

/**
  A struct to represent a request for paying a resource.

  - seealso:
    - `Resource`.
    - `Payable`.
 */
struct PaymentRequest<R: Resource>: Request {

  /// The identifier of a resource to pay.
  let id: Int

  // MARK: Request

  var method: Alamofire.Method {
    return .POST
  }

  let parameters: RequestParameters?

  func uri(baseURL baseURL: String) -> String {
    return (baseURL + R.name + "/\(id)/payments").appendJSONSuffix()
  }

}


extension Payable where PayableResource: Resource {

  public static func pay(id: Int, details: RequestParameters) -> Request {
    return PaymentRequest<PayableResource>(id: id, parameters: details)
  }

}
