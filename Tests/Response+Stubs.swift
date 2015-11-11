//
// Response+Stubs.swift
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

@testable import Quaderno


// MARK: StubbedHTTPResponse

/**
  Properties of a stubbed response returned when requesting a resource.
 */
protocol StubbedHTTPResponse {

  /// The HTTP code of a successful request.
  var successCode: Int { get }

  /// A stubbed response of a successful request.
  var successJSON: Response<NSError> { get }

  /// The HTTP code of an unsuccessful request.
  var failureCode: Int { get }

  /// A stubbed response of an unsuccessful request.
  var failureJSON: Response<NSError> { get }

  /// The HTTP headers returned with every response.
  var httpHeaders: HTTPHeaders? { get }

}

extension StubbedHTTPResponse {

  var successCode: Int {
    return 200
  }

  var successJSON: Response<NSError> {
    return .Record(["status": "OK"])
  }

  var failureCode: Int {
    return 400
  }

  var failureJSON: Response<NSError> {
    return .Failure(NSError(domain: "io.quaderno", code: failureCode, userInfo: ["error": "An error has occurred"]))
  }

  var httpHeaders: HTTPHeaders? {
    return [
      ConnectionEntitlements.HTTPHeader.Reset.rawValue: "15",
      ConnectionEntitlements.HTTPHeader.Remaining.rawValue: "100",
    ]
  }

}


// MARK: - Stubbed Responses


/// A stubbed response for a `Ping` resource.
struct PingResponse: StubbedHTTPResponse {}

/// A stubbed response for creating a `Contact` resource.
struct CreateContactResponse: StubbedHTTPResponse {

  var successJSON: Response<NSError> {
    return .Record([
      "id": 1,
      "kind": "person",
      "created_at": 1446997949,
      "first_name": "Zeus",
      "last_name": "Dyer",
      "full_name": "Zeus Dyer",
      "street_line_1": "Shelleystrasse 65",
      "street_line_2": NSNull(),
      "postal_code": "8427",
      "city": "Juvavbim",
      "region": "New Hampshire",
      "country": "OM",
      "phone_1": "(537) 386-5344",
      "phone_2": "(537) 386-5344",
      "fax": "(386) 933-4613",
      "email": "lepvi@example.com",
      "web": "http://example.com/gumiddo",
      "discount": 9.0,
      "tax_id": NSNull(),
      "vat_number": NSNull(),
      "language": "DE",
      "notes": "Siakafib weugo ra heztizig par cegam tijza is rul mudaaz dahi podwoj.",
      "secure_id": "f13936a86312h8a5d5a6a279kkb30da5e48ba1d5",
      "permalink": "https://quadernoapp.com/billing/f13936a86312h8a5d5a6a279kkb30da5e48ba1d5",
      "url": "http://quadernoapp.com/api/v1/contacts/1"
    ])
  }

}

/// A stubbed response for reading a `Contact` resource.
struct ReadContactResponse: StubbedHTTPResponse {

  var successJSON: Response<NSError> {
    return CreateContactResponse().successJSON
  }

}

/// A stubbed response for listing `Contact` resources.
struct ListContactResponse: StubbedHTTPResponse {

  var successJSON: Response<NSError> {
    switch ReadContactResponse().successJSON {
    case .Record(let value):
      return .Collection([value])
    default:
      return .Empty
    }
  }

}

/// A stubbed response for updating a `Contact` resource.
struct UpdateContactResponse: StubbedHTTPResponse {

  var successJSON: Response<NSError> {
    return ReadContactResponse().successJSON
  }

}

/// A stubbed response for deleting a `Contact` resource.
struct DeleteContactResponse: StubbedHTTPResponse {

  var successCode: Int {
    return 204
  }

  var successJSON: Response<NSError> {
    return .Empty
  }

}
