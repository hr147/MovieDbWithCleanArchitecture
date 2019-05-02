//
//  Networking.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

//1. Request

protocol RequestConvertible {}

//2. Request Routing

/// These are routes throughout the application.
/// Typically this is conformed to by methods routes.
protocol Routable {
    var route: String { get }
    init()
}

/// Allows a route to perform the `.get` method
protocol Readable: Routable {}

/// Allows a route to perform the `.post` method
protocol Creatable: Routable {}

/// Allows a route to perform the `.put` method
protocol Updatable: Routable {}

/// Allows a route to perform the `.delete` method
protocol Deletable: Routable {}

/// Allows a route to perform the `.patch` method
protocol Patchable: Routable {}

extension Routable {
    
    /// Create instance of Object that conforms to Routable
    init() {
        self.init()
    }
}


//3. Response
struct APIResponse<T> {
    let result: Result<T, Error>
}

//4. Task

protocol APIRequest {
    func cancel()
}

//4. Action
protocol APIDispatching {
    typealias Completion<T> = (APIResponse<T>) -> Void
    
    @discardableResult
    func dispatch<T: Decodable>(
        with request: RequestConvertible,
        completion: @escaping Completion<T>) -> APIRequest
}
