//
//  ContactTests.swift
//  Quaderno
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

import XCTest
import Alamofire


class ContactTests: XCTestCase {

  // MARK: Test Subjects

  var createContact: Contact!

  var readContact: Contact!

  var listContact: Contact!

  var updateContact: Contact!

  var deleteContact: Contact!

  var contactResources: [Contact]!

  // MARK: Set Up

  /// Dummy base URL.
  let baseURLString = "https://quadernoapp.com/api/v1/"

  /// Shortcut for `Method` enumeration.
  let method = Alamofire.Method

  // Sample record
  var contactParameters: Record?

  override func setUp() {
    super.setUp()

    contactParameters = Record()

    createContact = Contact(request: .Create(record: contactParameters!))
    readContact = Contact(request: .Read(id: 1))
    listContact = Contact(request: .List(page: 1))
    updateContact = Contact(request: .Update(id: 1, record: contactParameters!))
    deleteContact = Contact(request: .Delete(id: 1))

    contactResources = [createContact, readContact, listContact, updateContact, deleteContact]
  }

  // MARK: Examples

  func testThatContentTypeExtensionIsJSON() {
    contactResources.forEach { resource in
      XCTAssertEqual(resource.contentTypeExtension, ".json")
    }
  }

  func testThatURIStringIsValid() {
    var uriString: String

    uriString = createContact.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/contacts.json")
    XCTAssertNotNil(NSURL(string: uriString))

    uriString = readContact.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uriString))

    uriString = listContact.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/contacts.json")
    XCTAssertNotNil(NSURL(string: uriString))

    uriString = updateContact.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uriString))

    uriString = deleteContact.URIString(baseURLString: baseURLString)
    XCTAssertEqual(uriString, "https://quadernoapp.com/api/v1/contacts/1.json")
    XCTAssertNotNil(NSURL(string: uriString))
  }

  func testThatTheExpectedName() {
    contactResources.forEach { resource in
      XCTAssertEqual(resource.name, "contacts")
    }
  }

  func testThatProvidesTheExpectedPath() {
    XCTAssertEqual(createContact.path, "contacts.json")
    XCTAssertEqual(readContact.path, "contacts/1.json")
    XCTAssertEqual(listContact.path, "contacts.json")
    XCTAssertEqual(updateContact.path, "contacts/1.json")
    XCTAssertEqual(deleteContact.path, "contacts/1.json")
  }

  func testThatProvidesTheExpectedMethod() {
    XCTAssertEqual(createContact.method, method.POST)
    XCTAssertEqual(readContact.method, method.GET)
    XCTAssertEqual(listContact.method, method.GET)
    XCTAssertEqual(updateContact.method, method.PUT)
    XCTAssertEqual(deleteContact.method, method.DELETE)
  }

  func testThatProvidesTheExpectedParameters() {
    XCTAssertNotNil(createContact.parameters)
    XCTAssertNil(readContact.parameters)
    XCTAssertEqual(listContact.parameters?["page"] as? Int, 1)
    XCTAssertNotNil(updateContact.parameters)
    XCTAssertNil(deleteContact.parameters)
  }

}
