//
// CRUDRequest.swift
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

/**
  Request definitions for resources in the service that support CRUD operations.

  - seealso:
    - `CRUDResource`.
    - [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).
*/
public enum CRUDRequest {

  /// A request for creating a record.
  case Create(record: Record)

  /// A request for reading a single record.
  case Read(id: Int)

  /// A request for reading a collection of records.
  case List(page: Int)

  /// A request for updating a record.
  case Update(id: Int, record: Record)

  /// A request for deleting a record.
  case Delete(id: Int)

}
