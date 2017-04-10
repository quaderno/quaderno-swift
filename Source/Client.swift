//
// Client.swift
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

import Foundation
import Alamofire


/// An HTTP client sending requests to a web service exposing the Quaderno API.
///
/// - Seealso: [Quaderno API](https://quaderno.io/docs/api/).
open class Client {

    /// The base URL of the service.
    public let baseURL: URL

    /// The token authenticating every request.
    public let authenticationToken: String

    /// The HTTP headers authorizing every request.
    var authorizationHeaders: [String: String] {
        guard let credentialData = "\(authenticationToken):".data(using: String.Encoding.utf8) else {
            assertionFailure("Failed to encode the authentication token to UTF-8.")
            return [:]
        }

        let base64Credentials = credentialData.base64EncodedString()
        return ["Authorization": "Basic \(base64Credentials)"]
    }

    // MARK: Initialization

    /// Initialize a client with a base URL and an authentication token.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL of the web service.
    ///   - authenticationToken: The token authenticating every request.
    public init(baseURL: URL, authenticationToken: String) {
        self.baseURL             = baseURL
        self.authenticationToken = authenticationToken
    }

    // MARK: Connection Entitlements

    /// The entitlements granted to a client for using the web service.
    ///
    /// - Seealso: [Rate Limiting](https://quaderno.io/docs/api/#rate-limiting).
    public struct Entitlements {

        /// The time interval in seconds until `remainingRequests` is set to the maximum allowed value.
        public let resetInterval: TimeInterval

        /// The number of remaining requests until the next cycle.
        public let remainingRequests: Int

        /// Keys in HTTP header related to entitlements.
        enum HTTPHeader: String {

            case rateLimitReset             = "X-RateLimit-Reset"
            case rateLimitRemainingRequests = "X-RateLimit-Remaining"

        }

    }

    /// The entitlements currently granted.
    public fileprivate(set) var entitlements: Entitlements?

}


// MARK: - Sending Requests

private func noop<T>(_ value: T) {}

private extension HTTPMethod {

    var alamofired: Alamofire.HTTPMethod {
        guard let afMethod = Alamofire.HTTPMethod(rawValue: rawValue) else {
            fatalError("Failed to create the equivalent HTTP method of \(self) in Alamofire")
        }
        return afMethod
    }

}

extension Client.Entitlements {

    /// Initialize a set of entitlements with a dictionary of HTTP headers.
    ///
    /// - Precondition: All expected headers MUST be present.
    ///
    /// - Parameter httpHeaders: A dictionary of HTTP headers, as represented in `HTTPURLResponse`.
    init?(httpHeaders: [String: Any]) {
        guard let resetIntervalValue = httpHeaders[HTTPHeader.rateLimitReset.rawValue] as? String else {
            return nil
        }

        guard let resetInterval = TimeInterval(resetIntervalValue) else {
            return nil
        }

        guard let remainingRequestsValue = httpHeaders[HTTPHeader.rateLimitRemainingRequests.rawValue] as? String else {
            return nil
        }

        guard let remainingRequests = Int(remainingRequestsValue) else {
            return nil
        }

        self.resetInterval = resetInterval
        self.remainingRequests = remainingRequests
    }

    fileprivate static func updateEntitlements(of client: Client, with response: HTTPURLResponse?) {
        guard let httpHeaders = response?.allHeaderFields as? [String: Any] else {
            return
        }
        client.entitlements = Client.Entitlements(httpHeaders: httpHeaders)
    }

}

extension Client {

    private func dataRequest(validating request: Request) -> Alamofire.DataRequest {
        return Alamofire.request(request.uri(using: baseURL),
                                 method: request.method.alamofired,
                                 parameters: request.parameters,
                                 encoding: JSONEncoding.default,
                                 headers: authorizationHeaders).validate()
    }

    /// Send a request to the web service expecting a given response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - completion: A closure to execute once the request is finished.
    public func send<T>(_ request: Request, completion: @escaping (Response<T>) -> Void = noop) {
        dataRequest(validating: request).responseJSON { response in
            Entitlements.updateEntitlements(of: self, with: response.response)

            switch response.result {
            case .success(let value):
                if let transformedValue = value as? T {
                    completion(.success(transformedValue, Page(httpResponse: response.response)))
                } else {
                    let error = ErrorResponse.typeMismatch(expected: T.self, found: type(of: value))
                    completion(.failure(error))
                }
            case .failure(let error):
                let serviceError = ErrorResponse.serviceError(error as NSError)
                completion(.failure(serviceError))
            }
        }
    }

    /// Send a request to the web service expecting an empty response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - completion: A closure to execute once the request is finished.
    public func send(_ request: Request, completion: @escaping EmptyResponseHandler = noop) {
        dataRequest(validating: request).response { response in
            Entitlements.updateEntitlements(of: self, with: response.response)

            if let error = response.error {
                completion(.serviceError(error as NSError))
            } else {
                completion(nil)
            }
        }
    }

}


// MARK: - Sending a Ping Request

extension Client {

    struct PingRequest: Request {

        func uri(using baseURL: URL) -> URL {
            return baseURL.appendingPathComponent("ping").toJSON
        }

    }

    /// Ping the service.
    ///
    /// - Parameter completion: A closure to execute once the request is finished.
    ///
    /// - Seealso: [Ping the API](https://quaderno.io/docs/api/#authentication).
    public func ping(_ completion: @escaping EmptyResponseHandler = noop) {
        send(PingRequest(), completion: completion)
    }

}


// MARK: - Sending an Authorization Request

extension Client {

    struct AuthorizationRequest: Request {

        func uri(using baseURL: URL) -> URL {
            // Input base URL is ignored because the authorization resource is not tied to any account.
            guard let baseURL = URL(string: "https://quadernoapp.com/api") else {
                fatalError("Cannot build base URL for authorization")
            }

            return baseURL.appendingPathComponent("authorization").toJSON
        }

    }

    /// Ask the service for the account associated with an authorized user.
    ///
    /// - Parameter completion: A closure to execute once the request if finished
    ///
    /// - Seealso: [Authorization](https://quaderno.io/docs/api/#authorization).
    public func account(_ completion: @escaping JSONResponseHandler = noop) {
        send(AuthorizationRequest(), completion: completion)
    }

}
