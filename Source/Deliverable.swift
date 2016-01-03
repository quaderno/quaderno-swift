//
// Deliverable.swift
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


// MARK: - Deliverable

/**
  Requirements of a resource that can be delivered.
  
  - seealso: `Resource`.
 */
public protocol Deliverable {

  typealias DeliverableResource

  /**
    Creates a request for delivering a resource.

    - parameter id: The identifier of a resource.

    - returns: A request for delivering a resource.
   */
  static func deliver(id: Int) -> Request

}


// MARK:-

/**
  A struct to represent a request for delivering a resource.

  - seealso:
    - `Resource`.
    - `Deliverable`.
 */
struct DeliveryRequest<R: Resource>: Request {

  /// The identifier of a resource to deliver.
  let id: Int

  // MARK: Request

  var method: HTTPMethod {
    return .GET
  }

  var parameters: RequestParameters? {
    return nil
  }

  func uri(baseURL baseURL: String) -> String {
    return (baseURL + R.name + "/\(id)/deliver").appendJSONSuffix()
  }

}


extension Deliverable where DeliverableResource: Resource {

  public static func deliver(id: Int) -> Request {
    return DeliveryRequest<DeliverableResource>(id: id)
  }

}
