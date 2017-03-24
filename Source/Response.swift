//
// Response.swift
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


/// A response returned once a request is finished.
public enum Response<Value> {

    /// The request was successful.
    case success(Value, Page?)

    /// The request failed.
    case failure(ErrorResponse)

    /// Whether the response is an error.
    var isError: Bool {
        switch self {
        case .success:
            return false
        case .failure:
            return true
        }
    }

    /// The associated value in case of success.
    var value: Value? {
        guard case let .success(value, _) = self else {
            return nil
        }
        return value
    }

    /// The page in case of success.
    var page: Page? {
        guard case let .success(_, page) = self else {
            return nil
        }
        return page
    }

    /// The associated error in case of failure.
    var error: ErrorResponse? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }

}

/// A response handler for a JSON object.
public typealias JSONResponseHandler = (Response<[String: Any]>) -> Void

/// A response handler for an array of JSON objects.
public typealias JSONArrayResponseHandler = (Response<[[String: Any]]>) -> Void

/// A response handler for an empty response.
public typealias EmptyResponseHandler = (ErrorResponse?) -> Void


// MARK: -

/// Information about the page when request paginated results.
///
/// - Seealso: [Pagination](https://quaderno.io/docs/api/#pagination).
public struct Page {

    /// The number of the page returned in the response.
    let number: Int

    /// The total number of pages for the resource requested.
    let totalPages: Int

}

extension Page {

    /// Keys in HTTP header related to pagination.
    enum HTTPHeader: String {

        case currentPage = "X-Pages-CurrentPage"
        case totalPages  = "X-Pages-TotalPages"

    }

    /// Initialize a page with an HTTP response.
    ///
    /// - Parameter httpResponse: An HTTP response.
    init?(httpResponse: HTTPURLResponse?) {
        guard let httpHeaders = httpResponse?.allHeaderFields as? [String: Any] else {
            return nil
        }

        guard let currentPageValue = httpHeaders[HTTPHeader.currentPage.rawValue] as? String else {
            return nil
        }

        guard let currentPage = Int(currentPageValue) else {
            return nil
        }

        guard let totalPagesValue = httpHeaders[HTTPHeader.totalPages.rawValue] as? String else {
            return nil
        }

        guard let totalPages = Int(totalPagesValue) else {
            return nil
        }

        self.number = currentPage
        self.totalPages = totalPages
    }

}


// MARK: -

/// The errors that can occurred when processing a response.
public enum ErrorResponse: Error, CustomStringConvertible {

    /// A response returned a value type different than the one expected.
    case typeMismatch(expected: Any, found: Any)

    /// The associated request caused an error in the web service.
    case serviceError(NSError)

    // MARK: CustomStringConvertible

    public var description: String {
        switch self {
        case .typeMismatch(let expectedType, let actualType):
            return "The response was expected to be \(expectedType), but \(actualType) was found instead."
        case .serviceError(let error):
            return error.localizedDescription
        }
    }

}
