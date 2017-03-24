//
// PayableResource.swift
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


/// A resource that supports payment operations.
public protocol PayableResource: Resource {}


// MARK: - Creating Requests

/// The operations that can be performed on a payable resource.
public enum PaymentOperation: Operation {

    /// Creates a payment for a resource.
    case pay(Resource.Identifier, with: PaymentInstructions)

    /// Fetches all payments of a resource.
    case list(from: Resource.Identifier)

    /// Fetches a single payment from a resource.
    case read(Resource.Identifier, from: Resource.Identifier)

    /// Deletes a payment from a resource.
    case delete(Resource.Identifier, from: Resource.Identifier)

    var resourceIdentifier: Resource.Identifier {
        switch self {
        case .pay(let resource, _):
            return resource
        case .list(let resource):
            return resource
        case .read(_, let resource):
            return resource
        case .delete(_, let resource):
            return resource
        }
    }

    var paymentIdentifier: Resource.Identifier? {
        switch self {
        case .pay:
            fallthrough
        case .list:
            return nil
        case .read(let payment, _):
            return payment
        case .delete(let payment, _):
            return payment
        }
    }

}

/// The instructions to execute a payment.
///
/// - seealso: [Create a payment](https://quaderno.io/docs/api/#create-a-payment).
public struct PaymentInstructions {

    /// The payment methods.
    public enum Method: String {

        case creditCard = "credit_card"
        case cash = "cash"
        case wireTransfer = "wire_transfer"
        case directDebit = "direct_debit"
        case check = "check"
        case promissoryNote = "promissory_note"
        case iou = "iou"
        case payPal = "paypal"
        case other = "other"

    }

    /// The amount to be paid.
    let amount: Decimal

    /// The method used to execute the payment.
    let method: Method

    /// The date of the payment.
    let date: Date?

}

struct PaymentRequest<R: PayableResource>: Request {

    /// The operation to perform.
    let operation: PaymentOperation

    // MARK: Request

    var method: HTTPMethod {
        switch operation {
        case .pay:
            return .post
        case .list:
            fallthrough
        case .read:
            return .get
        case .delete:
            return .delete
        }
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    var parameters: HTTPParameters? {
        switch operation {
        case .pay(_, let instructions):
            var parameters: HTTPParameters = [
                "amount": instructions.amount.description,
                "payment_method": instructions.method.rawValue,
            ]

            if let paymentDate = instructions.date {
                parameters["date"] = dateFormatter.string(from: paymentDate)
            }

            return parameters
        case .list:
            fallthrough
        case .read:
            fallthrough
        case .delete:
            return nil
        }
    }

    func uri(using baseURL: URL) -> URL {
        var resourceURL = baseURL.appendingPathComponent(R.name)
            .appendingPathComponent(String(operation.resourceIdentifier))
            .appendingPathComponent("payments")

        if let paymentIdentifier = operation.paymentIdentifier {
            resourceURL.appendPathComponent(String(paymentIdentifier))
        }

        return resourceURL.toJSON
    }

}

extension Resource where Self: PayableResource {

    /// Build a request to perform a payment-related operation.
    ///
    /// - Parameter operation: The operation to perform.
    /// - Returns: A request configured to perform `operation`.
    public static func request(_ operation: PaymentOperation) -> Request {
        return PaymentRequest<Self>(operation: operation)
    }

}
