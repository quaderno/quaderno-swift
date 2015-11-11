//
// CRUD.swift
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

import Alamofire


// MARK: CRUD

/**
  Requirements of a resource that supports CRUD operations.

  - seealso:
    - `Resource`.
    - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).
 */
protocol CRUD {

  typealias CRUDResource

  /**
    Creates a request for creating a resource.
   
    - parameter attributes: The attributes of the resource.
   
    - returns: A request for creating a resource.
   */
  static func create(attributes: RequestParameters) -> Request

  /**
    Creates a request for reading a resource.

    - parameter id: The identifier of a resource.

    - returns: A request for reading a resource.
   */
  static func read(id: Int) -> Request

  /**
    Creates a request for reading a collection of resources.

    - parameter page: The page to filter the resources to fetch.

    - returns: A request for reading a collection of resources.
   */
  static func list(page: Int) -> Request

  /**
    Creates a request for updating a resource.

    - parameter id:         The identifier of the resource.
    - parameter attributes: The attributes of the resource.

    - returns: A request for updating a resource.
   */
  static func update(id: Int, attributes: RequestParameters) -> Request

  /**
    Creates a request for deleting a resource.

    - parameter id: The identifier of a resource.

    - returns: A request for deleting a resource.
   */
  static func delete(id: Int) -> Request

}


// MARK:- CRUDRequest

/**
  Available CRUD requests.
 */
enum CRUDRequest<R: Resource>: Request {

  /// A request for creating a resource.
  case Create(RequestParameters)

  /// A request for reading a resource.
  case Read(Int)

  /// A request for creating a collection of resources.
  case List(Int)

  /// A request for updating a resource.
  case Update(Int, RequestParameters)

  /// A request for deleting a resource.
  case Delete(Int)

  // MARK: Request

  var method: Alamofire.Method {
    switch self {
    case .Create:
      return .POST
    case .Read, .List:
      return .GET
    case .Update:
      return .PUT
    case .Delete:
      return .DELETE
    }
  }

  var parameters: RequestParameters? {
    switch self {
    case .Create(let attributes):
      return attributes
    case .Read, .List, .Delete:
      return nil
    case .Update(_, let attributes):
      return attributes
    }
  }

  func uri(baseURL baseURL: String) -> String {
    let path: String
    switch self {
    case .Create:
      path = R.name.appendJSONSuffix()
    case let .Read(id):
      path = (R.name + "/\(id)").appendJSONSuffix()
    case let .List(page):
      path = R.name.appendJSONSuffix() + "?page=\(page)"
    case let .Update(id, _):
      path = (R.name + "/\(id)").appendJSONSuffix()
    case let .Delete(id):
      path = (R.name + "/\(id)").appendJSONSuffix()
    }
    return baseURL + path
  }

}


// MARK:-

extension CRUD where CRUDResource: Resource {

  static func create(attributes: RequestParameters) -> Request {
    return CRUDRequest<CRUDResource>.Create(attributes)
  }

  static func read(id: Int) -> Request {
    return CRUDRequest<CRUDResource>.Read(id)
  }

  static func list(page: Int = 1) -> Request {
    return CRUDRequest<CRUDResource>.List(page)
  }

  static func update(id: Int, attributes: RequestParameters) -> Request {
    return CRUDRequest<CRUDResource>.Update(id, attributes)
  }

  static func delete(id: Int) -> Request {
    return CRUDRequest<CRUDResource>.Delete(id)
  }
  
}
