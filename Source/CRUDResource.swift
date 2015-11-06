//
// CRUDResource.swift
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

/**
  Requirements of a resource that supports CRUD operations.

  - seealso:
    - `CRUDRequest`.
    - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).
 */
public protocol CRUDResource: Resource {

  /// Request associated with a resource.
  var request: CRUDRequest { get }

}


public extension CRUDResource {

  var method: Alamofire.Method {
    switch request {
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

  var path: String {
    switch request {
    case .Create, .List:
      return name + contentTypeExtension
    case .Read (let id):
      return name + "/" + String(id) + contentTypeExtension
    case .Update(let id, _):
      return name + "/" + String(id) + contentTypeExtension
    case .Delete(let id):
      return name + "/" + String(id) + contentTypeExtension
    }
  }

  var parameters: Record? {
    switch request {
    case .Create(let record):
      return record
    case .Read, .Delete:
      return nil
    case .List(let page):
      return ["page": page]
    case .Update (_, let record):
      return record
    }
  }

}
