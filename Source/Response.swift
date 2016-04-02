//
// Response.swift
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


/// Alias for objects returned in response to requests.
public typealias ResponseObject = [String: AnyObject]


// MARK: - Response

/**
 Represents a response returned as a result of a request to a resource. Any
 response except `Failure` is considered successful.

 - `Record`: The request was successful and a single record was returned as a
 result.

 - `Collection`: The request was successful and a collection of records was
 returned as a result.

 - `Empty`: The request was successful but nothing was returned as a result.

 - `Failure`: The request failed and an error that caused the failure is
 reported.
 */
public enum Response<Error: ErrorType> {

  case Record(ResponseObject)
  case Collection([ResponseObject])
  case Empty
  case Failure(Error)

  /// Whether the response is considered successful.
  public var isSuccess: Bool {
    switch self {
    case .Failure:
      return false
    default:
      return true
    }
  }

  /// Whether the response is considered a failed response.
  public var isFailure: Bool {
    return !isSuccess
  }

}
