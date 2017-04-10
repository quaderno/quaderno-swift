//
// TaxResource.swift
//
// Copyright (c) 2017 Recrea (http://recreahq.com/)
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


// MARK: -

/// A resource to calculate and validate taxes.
///
/// - seealso: [Taxes](https://quaderno.io/docs/api/#taxes)
public protocol TaxResource: Resource {

}


// MARK: - Default Implementation

extension TaxResource {

    public static var name: String {
        return "taxes"
    }

}


// MARK: - Creating Requests

/// The operations that can be performed with taxes.
public enum TaxOperation: Operation {

    /// Calculate the taxes of a transaction.
    case calculate(for: Transaction)

    /// Validates a VAT number from a country.
    case validate(vat: String, country: String)

}

/// A transaction subject to taxes.
public struct Transaction {

    /// The categories of transactions.
    public enum Category: String {

        case service = "eservice"
        case book = "ebook"
        case standard = "standard"

    }

    /// A two-letter string representing a country code as defined by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
    let country: String

    /// The postal code of a customer.
    let postalCode: String?

    /// The VAT number of a customer.
    let vatNumber: String?

    /// The category of the transaction. The default value is `.service`.
    let category: Category?

    /// Initialize a transaction.
    ///
    /// - Parameters:
    ///   - country: The country code.
    ///   - postalCode: The postal code.
    ///   - vatNumber: The VAT number.
    ///   - category: The category.
    init(country: String, postalCode: String? = nil, vatNumber: String? = nil, category: Category? = nil) {
        self.country = country
        self.postalCode = postalCode
        self.vatNumber = vatNumber
        self.category = category
    }

}

struct TaxRequest<R: TaxResource>: Request {

    let operation: TaxOperation

    // MARK: Request

    let method: HTTPMethod = .get

    var parameters: HTTPParameters? {
        var parameters: HTTPParameters = [:]
        switch operation {
        case .calculate(let transaction):
            parameters["country"] = transaction.country

            if let category = transaction.category {
                parameters["transaction_type"] = category.rawValue
            }

            if let postalCode = transaction.postalCode {
                parameters["postal_code"] = postalCode
            }

            if let vatNumber = transaction.vatNumber {
                parameters["vat_number"] = vatNumber
            }
        case .validate(let vat, let country):
            parameters["country"] = country
            parameters["vat_number"] = vat
        }
        return parameters
    }

    func uri(using baseURL: URL) -> URL {
        let pathName: String
        switch operation {
        case .calculate:
            pathName = "calculate"
        case .validate:
            pathName = "validate"
        }

        return baseURL.appendingPathComponent(R.name)
            .appendingPathComponent(pathName)
            .toJSON
    }

}

extension TaxResource {

    /// Build a request to perform a tax-related operation.
    ///
    /// - Parameter operation: The operation to perform.
    /// - Returns: A request configured to perform `operation`.
    public static func request(_ operation: TaxOperation) -> Request {
        return TaxRequest<Self>(operation: operation)
    }

}
