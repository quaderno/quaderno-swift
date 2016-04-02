//
// Tax.swift
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


/**
 A resource for calculating taxes.

 - seealso: [Taxes](https://github.com/quaderno/quaderno-api/blob/master/sections/taxes.md).
 */
public struct Tax: Resource {

  // MARK: Resource

  public static let name = "taxes"

  // MARK: Transaction Types

  /**
   Represents a type of transaction involved in tax calculation.

   - `Service`: A transaction.
   - `Book`: A transaction.
   - `Standard`: A transaction.
   */
  public enum TransactionType: String {
    case Service = "eservice"
    case Book = "ebook"
    case Standard = "standard"
  }

  // MARK: Calculating Taxes

  /**
   A request for calculating taxes.

   - seealso:
    - `Request`.
    - `TaxData`.
   */
  struct CalculateRequest: Request {

    /// The transaction details to calcutate taxes for.
    let transactionDetails: TransactionDetails

    // MARK: Request

    var method: HTTPMethod {
      return .GET
    }

    var parameters: RequestParameters? {
      var parameters: RequestParameters = [
        "country": transactionDetails.country,
        "transaction_type": transactionDetails.type.rawValue,
      ]

      if let postalCode = transactionDetails.postalCode {
        parameters["postal_code"] = postalCode
      }

      if let vatNumber = transactionDetails.vatNumber {
        parameters["vat_number"] = vatNumber
      }

      return parameters
    }

    func uri(baseURL baseURL: String) -> String {
      return (baseURL + Tax.name + "/calculate").appendJSONSuffix()
    }

  }

  /**
   The details of a transaction suitable for calculating its taxes.
   */
  public struct TransactionDetails {

    /// A two-letter string representing a country code as defined by [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
    let country: String

    /// The postal code of a customer.
    let postalCode: String?

    /// The VAT number of a customer.
    let vatNumber: String?

    /// The type of transaction. The default value is `Service`.
    let type: TransactionType

    /**
     Initializes the details of a transaction.

     - parameter country:    The country code.
     - parameter postalCode: The postal code.
     - parameter vatNumber:  The VAT number.
     - parameter type:       The transaction type.

     - returns: A newly initialized transaction.
     */
    init(country: String, postalCode: String? = nil, vatNumber: String? = nil, type: TransactionType = .Service) {
      self.country = country
      self.postalCode = postalCode
      self.vatNumber = vatNumber
      self.type = type
    }

  }

  /**
   Creates a request for calculating the taxes to apply to a given customer.

   - parameter transactionDetails: The details of a transaction.

   - returns: A request for calculating the taxes.
   */
  public static func calculate(transactionDetails: TransactionDetails) -> Request {
    return CalculateRequest(transactionDetails: transactionDetails)
  }

}
