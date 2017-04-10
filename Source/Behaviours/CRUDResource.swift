//
// CRUDResource.swift
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


/// A resource that supports CRUD operations
public protocol CRUDResource: Resource {}


// MARK: - Creating Requests

/// The CRUD operations that can be performed on a resource.
public enum CRUD: Operation {

    /// Create a resource with given parameters.
    case create(HTTPParameters)

    /// Fetches all instances of a resource.
    case list

    /// Fetches a single instance of a resource.
    case read(Resource.Identifier)

    /// Updates a single instance of a resource with given parameters.
    case update(Resource.Identifier, HTTPParameters)

    /// Deletes a single instance of a resource.
    case delete(Resource.Identifier)

}

struct CRUDRequest<R: CRUDResource>: Request {

    /// The CRUD operation to perform.
    let operation: CRUD

    // MARK: Request

    var method: HTTPMethod {
        switch operation {
        case .create:
            return .post
        case .list:
            fallthrough
        case .read:
            return .get
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var parameters: HTTPParameters? {
        switch operation {
        case .create(let parameters):
            return parameters
        case .list:
            return nil
        case .read:
            return nil
        case .update(_, let parameters):
            return parameters
        case .delete:
            return nil
        }
    }

    func uri(using baseURL: URL) -> URL {
        var resourceURL = baseURL.appendingPathComponent(R.name)
        switch operation {
        case .create:
            fallthrough
        case .list:
            break
        case .read(let remoteIdentifier):
            resourceURL.appendPathComponent(String(remoteIdentifier))
        case .update(let remoteIdentifier, _):
            resourceURL.appendPathComponent(String(remoteIdentifier))
        case .delete(let remoteIdentifier):
            resourceURL.appendPathComponent(String(remoteIdentifier))
        }
        return resourceURL.toJSON
    }

}

extension Resource where Self: CRUDResource {

    /// Build a request to perform a CRUD operation.
    ///
    /// - Parameter operation: The operation to perform.
    /// - Returns: A request configured to perform `operation`.
    public static func request(_ operation: CRUD) -> Request {
        return CRUDRequest<Self>(operation: operation)
    }

}
