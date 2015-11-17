//
// OHHTTPStubs+Quaderno.swift
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
import OHHTTPStubs


// MARK: - OHHTTPStubs Matchers

/**
  Matcher testing that the `NSURLRequest` is using a given HTTP method.

  - parameter method: An HTTP method to query the request against.
  - returns:          A matcher (OHHTTPStubsTestBlock) that succeeds only if the request is using the given method.
 */
func isMethod(method: Alamofire.Method) -> OHHTTPStubsTestBlock {
  return { $0.HTTPMethod == method.rawValue }
}

/**
  Matcher testing that the URL of a `NSURLRequest` has `path` as a suffix.

  - parameter path: A path to query the request against.
  - returns:        A matcher (OHHTTPStubsTestBlock) that succeeds only if the URL has `path` as a suffix.
 */
func containsPath(path: String) -> OHHTTPStubsTestBlock {
  return { request in
    guard let url = request.URL else {
      return false
    }
    return url.absoluteString.hasSuffix(path)
  }
}


// MARK: -

extension OHHTTPStubs {

  // MARK: Helpers

  /**
    Stubs a request that matches a given method and path, and provides a stubbed response.

    - parameter method:   The HTTP method of the request to stub.
    - parameter path:     The relative path of the request to stub.
    - parameter response: A stubbed response to provide as the result of the request.
  */
  final class func stubRequest(method method: Alamofire.Method, path: String, response: OHHTTPStubsResponse) {
    stub(isMethod(method) && containsPath(path)) { _ in return response }
  }

  /**
    Stubs a response to provide as the result of a request.

    - parameter response: A response to stub.
    - parameter success:  Whether the response should be stubbed as successful.

    - returns: A stubbed response to provide when stubbing requests.

    - seealso: `stubRequest(method:path:response)`
   */
  final class func stubResponse(response: StubbedHTTPResponse, success: Bool) -> OHHTTPStubsResponse {
    let responseObject = (success ? response.successJSON : response.failureJSON)

    let JSONObject: AnyObject
    switch responseObject {
    case .Record(let record):
      JSONObject = record
    case .Collection(let list):
      JSONObject = list
    default:
      JSONObject = []
    }

    let statusCode = (success ? response.successCode : response.failureCode)
    return OHHTTPStubsResponse(JSONObject: JSONObject, statusCode: CInt(statusCode), headers: response.httpHeaders)
  }

  // MARK: Common Stubs

  /**
    Stubs a request to a `Ping` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `PingResponse`.
   */
  final class func stubPingRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let pingResponse = response ?? stubResponse(PingResponse(), success: success)
    stubRequest(method: .GET, path: "ping.json", response: pingResponse)
  }

  /**
    Stubs a request to a `Authorization` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `AuthorizationResponse`.
   */
  final class func stubAuthorizationRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let authorizationResponse = response ?? stubResponse(AuthorizationResponse(), success: success)
    stubRequest(method: .GET, path: "authorization.json", response: authorizationResponse)
  }

  /**
    Stubs a request for creating a `Contact` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `CreateContactResponse`.
   */
  final class func stubCreateContactRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let createContactResponse = response ?? stubResponse(CreateContactResponse(), success: success)
    stubRequest(method: .POST, path: "contacts.json", response: createContactResponse)
  }

  /**
    Stubs a request for reading a `Contact` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `ReadContactResponse`.
   */
  final class func stubReadContactRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let readContactResponse = response ?? stubResponse(ReadContactResponse(), success: success)
    stubRequest(method: .GET, path: "contacts/1.json", response: readContactResponse)
  }

  /**
    Stubs a request for listing a collection of `Contact` resources.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `ListContactResponse`.
   */
  final class func stubListContactRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let listContactResponse = response ?? stubResponse(ListContactResponse(), success: success)
    stubRequest(method: .GET, path: "contacts.json?page=1", response: listContactResponse)
  }

  /**
    Stubs a request for updating a `Contact` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `UpdateContactResponse`.
   */
  final class func stubUpdateContactRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let updateContactResponse = response ?? stubResponse(UpdateContactResponse(), success: success)
    stubRequest(method: .PUT, path: "contacts/1.json", response: updateContactResponse)
  }

  /**
    Stubs a request for deleting a `Contact` resource.

    - parameter success:  Whether the stubbed response should be successful.
    - parameter response: An optional stubbed response to overrides the default response.

    - seealso: `DeleteContactResponse`.
   */
  final class func stubDeleteContactRequest(success success: Bool, response: OHHTTPStubsResponse? = nil) {
    let deleteContactResponse = response ?? stubResponse(DeleteContactResponse(), success: success)
    stubRequest(method: .DELETE, path: "contacts/1.json", response: deleteContactResponse)
  }

}
