//
// ResourceTests.swift
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

import XCTest

@testable import Quaderno

final class ResourceTests: TestCase {

    // MARK: CRUD

    private let crudResources: [CRUDResource.Type] = [
        Contact.self,
        Receipt.self,
        Invoice.self,
        Credit.self,
        Expense.self,
        Estimate.self,
        Recurring.self,
        Item.self,
        Webhook.self,
        Evidence.self,
    ]

    func testThatResourcesCanBeCreated() {
        crudResources.forEach {
            let request = $0.request(.create(["name": "John Doe"]))
            XCTAssert(request.method == .post)
            XCTAssert(request.parameters?.count == 1)
            XCTAssert(request.parameters?["name"] as? String == "John Doe")

            let path: String?
            switch $0 {
            case is Contact.Type:
                path = "/contacts.json"
            case is Receipt.Type:
                path = "/receipts.json"
            case is Invoice.Type:
                path = "/invoices.json"
            case is Credit.Type:
                path = "/credits.json"
            case is Expense.Type:
                path = "/expenses.json"
            case is Estimate.Type:
                path = "/estimates.json"
            case is Recurring.Type:
                path = "/recurring.json"
            case is Item.Type:
                path = "/items.json"
            case is Webhook.Type:
                path = "/webhooks.json"
            case is Evidence.Type:
                path = "/evidences.json"
            default:
                path = nil
            }

            if let resourcePath = path {
                XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: resourcePath))
            } else {
                XCTFail("CRUD resource not tested: \($0)")
            }
        }
    }

    func testThatResourcesCanBeListed() {
        crudResources.forEach {
            let request = $0.request(.list)
            XCTAssert(request.method == .get)
            XCTAssertNil(request.parameters)

            let path: String?
            switch $0 {
            case is Contact.Type:
                path = "/contacts.json"
            case is Receipt.Type:
                path = "/receipts.json"
            case is Invoice.Type:
                path = "/invoices.json"
            case is Credit.Type:
                path = "/credits.json"
            case is Expense.Type:
                path = "/expenses.json"
            case is Estimate.Type:
                path = "/estimates.json"
            case is Recurring.Type:
                path = "/recurring.json"
            case is Item.Type:
                path = "/items.json"
            case is Webhook.Type:
                path = "/webhooks.json"
            case is Evidence.Type:
                path = "/evidences.json"
            default:
                path = nil
            }

            if let resourcePath = path {
                XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: resourcePath))
            } else {
                XCTFail("CRUD resource not tested: \($0)")
            }
        }
    }

    func testThatResourcesCanBeRead() {
        crudResources.forEach {
            let identifier = generateResourceIdentifier()
            let request = $0.request(.read(identifier))
            XCTAssert(request.method == .get)
            XCTAssertNil(request.parameters)

            let path: String?
            switch $0 {
            case is Contact.Type:
                path = "/contacts/\(identifier).json"
            case is Receipt.Type:
                path = "/receipts/\(identifier).json"
            case is Invoice.Type:
                path = "/invoices/\(identifier).json"
            case is Credit.Type:
                path = "/credits/\(identifier).json"
            case is Expense.Type:
                path = "/expenses/\(identifier).json"
            case is Estimate.Type:
                path = "/estimates/\(identifier).json"
            case is Recurring.Type:
                path = "/recurring/\(identifier).json"
            case is Item.Type:
                path = "/items/\(identifier).json"
            case is Webhook.Type:
                path = "/webhooks/\(identifier).json"
            case is Evidence.Type:
                path = "/evidences/\(identifier).json"
            default:
                path = nil
            }

            if let resourcePath = path {
                XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: resourcePath))
            } else {
                XCTFail("CRUD resource not tested: \($0)")
            }
        }
    }

    func testThatResourcesCanBeUpdated() {
        crudResources.forEach {
            let identifier = generateResourceIdentifier()
            let request = $0.request(.update(identifier, ["name": "John Doe"]))
            XCTAssert(request.method == .put)
            XCTAssert(request.parameters?.count == 1)
            XCTAssert(request.parameters?["name"] as? String == "John Doe")

            let path: String?
            switch $0 {
            case is Contact.Type:
                path = "/contacts/\(identifier).json"
            case is Receipt.Type:
                path = "/receipts/\(identifier).json"
            case is Invoice.Type:
                path = "/invoices/\(identifier).json"
            case is Credit.Type:
                path = "/credits/\(identifier).json"
            case is Expense.Type:
                path = "/expenses/\(identifier).json"
            case is Estimate.Type:
                path = "/estimates/\(identifier).json"
            case is Recurring.Type:
                path = "/recurring/\(identifier).json"
            case is Item.Type:
                path = "/items/\(identifier).json"
            case is Webhook.Type:
                path = "/webhooks/\(identifier).json"
            case is Evidence.Type:
                path = "/evidences/\(identifier).json"
            default:
                path = nil
            }

            if let resourcePath = path {
                XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: resourcePath))
            } else {
                XCTFail("CRUD resource not tested: \($0)")
            }
        }
    }

    func testThatResourcesCanBeDeleted() {
        crudResources.forEach {
            let identifier = generateResourceIdentifier()
            let request = $0.request(.delete(identifier))
            XCTAssert(request.method == .delete)
            XCTAssertNil(request.parameters)

            let path: String?
            switch $0 {
            case is Contact.Type:
                path = "/contacts/\(identifier).json"
            case is Receipt.Type:
                path = "/receipts/\(identifier).json"
            case is Invoice.Type:
                path = "/invoices/\(identifier).json"
            case is Credit.Type:
                path = "/credits/\(identifier).json"
            case is Expense.Type:
                path = "/expenses/\(identifier).json"
            case is Estimate.Type:
                path = "/estimates/\(identifier).json"
            case is Recurring.Type:
                path = "/recurring/\(identifier).json"
            case is Item.Type:
                path = "/items/\(identifier).json"
            case is Webhook.Type:
                path = "/webhooks/\(identifier).json"
            case is Evidence.Type:
                path = "/evidences/\(identifier).json"
            default:
                path = nil
            }

            if let resourcePath = path {
                XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: resourcePath))
            } else {
                XCTFail("CRUD resource not tested: \($0)")
            }
        }
    }

    // MARK: Deliverable

    func testThatReceiptsCanBeDelivered() {
        let receiptIdentifier = generateResourceIdentifier()
        let request = Receipt.request(.deliver(receiptIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/receipts/\(receiptIdentifier)/deliver.json"))
    }

    func testThatInvoicesCanBeDelivered() {
        let invoiceIdentifier = generateResourceIdentifier()
        let request = Invoice.request(.deliver(invoiceIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/invoices/\(invoiceIdentifier)/deliver.json"))
    }

    func testThatCreditsCanBeDelivered() {
        let creditIdentifier = generateResourceIdentifier()
        let request = Credit.request(.deliver(creditIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/credits/\(creditIdentifier)/deliver.json"))
    }

    func testThatEstimatesCanBeDelivered() {
        let estimateIdentifier = generateResourceIdentifier()
        let request = Estimate.request(.deliver(estimateIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/estimates/\(estimateIdentifier)/deliver.json"))
    }

    // MARK: Payable

    func testThatInvoicesCanBePaid() {
        let invoiceIdentifier = generateResourceIdentifier()
        let instructions = PaymentInstructions(amount: 12.3, method: .creditCard, date: nil)
        let request = Invoice.request(.pay(invoiceIdentifier, with: instructions))
        XCTAssert(request.method == .post)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/invoices/\(invoiceIdentifier)/payments.json"))

        XCTAssert(request.parameters?.count == 2)
        XCTAssert(request.parameters?["amount"] as? String == "12.3")
        XCTAssert(request.parameters?["payment_method"] as? String == "credit_card")
    }

    func testThatExpensesCanBePaid() {
        let paymentDate = Date()
        let expenseIdentifier = generateResourceIdentifier()
        let instructions = PaymentInstructions(amount: 12.3, method: .creditCard, date: paymentDate)
        let request = Expense.request(.pay(expenseIdentifier, with: instructions))
        XCTAssert(request.method == .post)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/expenses/\(expenseIdentifier)/payments.json"))

        XCTAssert(request.parameters?.count == 3)
        XCTAssert(request.parameters?["amount"] as? String == "12.3")
        XCTAssert(request.parameters?["payment_method"] as? String == "credit_card")

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: paymentDate)
        let expectedDate = String(format: "%04zd-%02zd-%02zd", dateComponents.year!, dateComponents.month!, dateComponents.day!)
        XCTAssert(request.parameters?["date"] as? String == expectedDate)
    }

    func testThatPaymentsCanBeMadeForEachPaymentMethod() {
        let paymentMethods: [PaymentInstructions.Method: String] = [
            .creditCard: "credit_card",
            .cash: "cash",
            .wireTransfer: "wire_transfer",
            .directDebit: "direct_debit",
            .check: "check",
            .promissoryNote: "promissory_note",
            .iou: "iou",
            .payPal: "paypal",
            .other: "other",
        ]
        paymentMethods.forEach { method, expectedValue in
            let paymentInstructions = PaymentInstructions(amount: 12.3, method: method, date: nil)
            let request = Invoice.request(.pay(1, with: paymentInstructions))
            XCTAssert(request.parameters?["payment_method"] as? String == expectedValue)
        }
    }

    func testThatInvoicePaymentsCanBeListed() {
        let invoiceIdentifier = generateResourceIdentifier()
        let request = Invoice.request(.list(from: invoiceIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/invoices/\(invoiceIdentifier)/payments.json"))
    }

    func testThatExpensePaymentsCanBeListed() {
        let expenseIdentifier = generateResourceIdentifier()
        let request = Expense.request(.list(from: expenseIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/expenses/\(expenseIdentifier)/payments.json"))
    }

    func testThatInvoicePaymentsCanBeRead() {
        let invoiceIdentifier = generateResourceIdentifier()
        let paymentIdentifier = generateResourceIdentifier()
        let request = Invoice.request(.read(paymentIdentifier, from: invoiceIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/invoices/\(invoiceIdentifier)/payments/\(paymentIdentifier).json"))
    }

    func testThatExpensePaymentsCanBeRead() {
        let expenseIdentifier = generateResourceIdentifier()
        let paymentIdentifier = generateResourceIdentifier()
        let request = Expense.request(.read(paymentIdentifier, from: expenseIdentifier))
        XCTAssert(request.method == .get)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/expenses/\(expenseIdentifier)/payments/\(paymentIdentifier).json"))
    }

    func testThatInvoicePaymentsCanBeDeleted() {
        let invoiceIdentifier = generateResourceIdentifier()
        let paymentIdentifier = generateResourceIdentifier()
        let request = Invoice.request(.delete(paymentIdentifier, from: invoiceIdentifier))
        XCTAssert(request.method == .delete)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/invoices/\(invoiceIdentifier)/payments/\(paymentIdentifier).json"))
    }

    func testThatExpensePaymentsCanBeDeleted() {
        let expenseIdentifier = generateResourceIdentifier()
        let paymentIdentifier = generateResourceIdentifier()
        let request = Expense.request(.delete(paymentIdentifier, from: expenseIdentifier))
        XCTAssert(request.method == .delete)
        XCTAssert(request.parameters == nil)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/expenses/\(expenseIdentifier)/payments/\(paymentIdentifier).json"))
    }

    // MARK: Taxes

    func testThatTaxesCanBeCalculated() {
        let transaction1 = Transaction(country: "ES")
        let request1 = Tax.request(.calculate(for: transaction1))
        XCTAssert(request1.method == .get)
        XCTAssert(uri(for: request1) == uri(byAppendingPathToBaseURL: "/taxes/calculate.json"))
        XCTAssert(request1.parameters?.count == 1)
        XCTAssert(request1.parameters?["country"] as? String == "ES")

        let transaction2 = Transaction(country: "ES", postalCode: "35018")
        let request2 = Tax.request(.calculate(for: transaction2))
        XCTAssert(request2.method == .get)
        XCTAssert(uri(for: request2) == uri(byAppendingPathToBaseURL: "/taxes/calculate.json"))
        XCTAssert(request2.parameters?.count == 2)
        XCTAssert(request2.parameters?["country"] as? String == "ES")
        XCTAssert(request2.parameters?["postal_code"] as? String == "35018")

        let transaction3 = Transaction(country: "ES", postalCode: "35018", vatNumber: "98765432X")
        let request3 = Tax.request(.calculate(for: transaction3))
        XCTAssert(request3.method == .get)
        XCTAssert(uri(for: request3) == uri(byAppendingPathToBaseURL: "/taxes/calculate.json"))
        XCTAssert(request3.parameters?.count == 3)
        XCTAssert(request3.parameters?["country"] as? String == "ES")
        XCTAssert(request3.parameters?["postal_code"] as? String == "35018")
        XCTAssert(request3.parameters?["vat_number"] as? String == "98765432X")

        let transaction4 = Transaction(country: "ES", postalCode: "35018", vatNumber: "98765432X", category: .service)
        let request4 = Tax.request(.calculate(for: transaction4))
        XCTAssert(request4.method == .get)
        XCTAssert(uri(for: request4) == uri(byAppendingPathToBaseURL: "/taxes/calculate.json"))
        XCTAssert(request4.parameters?.count == 4)
        XCTAssert(request4.parameters?["country"] as? String == "ES")
        XCTAssert(request4.parameters?["postal_code"] as? String == "35018")
        XCTAssert(request4.parameters?["vat_number"] as? String == "98765432X")
        XCTAssert(request4.parameters?["transaction_type"] as? String == "eservice")
    }

    func testThatTaxesCanBeCalculatedForEachTransactionTypes() {
        let transactionTypes: [Transaction.Category: String] = [
            .service: "eservice",
            .book: "ebook",
            .standard: "standard",
        ]
        transactionTypes.forEach { category, expectedValue in
            let transaction = Transaction(country: "ES", category: category)
            let request = Tax.request(.calculate(for: transaction))
            XCTAssert(request.parameters?["transaction_type"] as? String == expectedValue)
        }
    }

    func testThatTaxesCanBeValidated() {
        let request = Tax.request(.validate(vat: "98765432X", country: "ES"))
        XCTAssert(request.method == .get)
        XCTAssert(uri(for: request) == uri(byAppendingPathToBaseURL: "/taxes/validate.json"))
        XCTAssert(request.parameters?.count == 2)
        XCTAssert(request.parameters?["country"] as? String == "ES")
        XCTAssert(request.parameters?["vat_number"] as? String == "98765432X")
    }

}
