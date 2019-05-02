//
//  NetworkManager.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation
import Alamofire

//1. Request
struct RequestConverter<T: Encodable>: RequestConvertible {
    let method: HTTPMethod
    let endPoint: String
    var parameters: T?
    let encoder: Alamofire.ParameterEncoder
}

extension RequestConverter: URLRequestConvertible {
    /// Required method to conform to the `URLRequestConvertible` protocol.
    ///
    /// - Returns: URLRequest object
    /// - Throws: An `Error` if the underlying `URLRequest` is `nil`.
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURL.asURL().appendingPathComponent(endPoint)
        let request = try URLRequest(url: url, method: method)
        //urlRequest.allHTTPHeaderFields = headers?.toHeader()
        
        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}



extension Readable {
    
    /// Method that allows route to return an object
    ///
    /// - Parameter params:
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    ///
    ///````
    static func get<T: Encodable>(parameters: T? = nil) -> RequestConvertible {
        let router = Self.init()
        
        return RequestConverter(method: .get,
                                endPoint: router.route,
                                parameters: parameters,
                                encoder: URLEncodedFormParameterEncoder.default)
    }
}

extension Creatable {
    
    /// Method that allows route to create an object
    ///
    /// - Parameter parameters:
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    /// 
    ///````
    static func create<T: Encodable>(parameters: T? = nil) -> RequestConvertible {
        let router = Self.init()
        return RequestConverter(method: .post,
                                endPoint: router.route,
                                parameters: parameters,
                                encoder: JSONParameterEncoder.default)
    }
}

extension Updatable {
    
    /// Method that allows route to update an object
    ///
    /// - Parameter parameters:
    /// - Returns: `URLRequestConvertible` object to play nicely with Alamofire
    /// ````
    ///
    ///````
    static func update<T: Encodable>(parameters: T? = nil) -> RequestConvertible {
        let router = Self.init()
        return RequestConverter(method: .put,
                                endPoint: router.route,
                                parameters: parameters,
                                encoder: JSONParameterEncoder.default)
    }
}



//2. Request Route configuration
struct APIRouter {
    static let baseURL = Constants.API.baseURL
    
    struct Movie: Readable {
        let route: String = "movie/now_playing"
    }
    
}


//3. Request Cancelable

struct DefaultAPIRequest: APIRequest {
    var request: DataRequest?
    func cancel() {
        request?.cancel()
    }
}

//4. Request Failure
struct RequestFailure: LocalizedError {
    var localizedDescription: String {
        return "invalid request"
    }
}

//5. Request Dispatching
final class NetworkManager: APIDispatching {
    static let shared = NetworkManager()
    
    private init() {}
    
    
    @discardableResult
    func dispatch<T: Decodable>(
        with request: RequestConvertible,
        completion: @escaping Completion<T>) -> APIRequest {
        
        guard let request = request as? URLRequestConvertible else {
            completion(APIResponse(result: .failure(RequestFailure())))
            return DefaultAPIRequest()
        }
        
        let dispatchedRequest = AF.request(request)
            .validate()
            .responseDecodable { (response: DataResponse<T>) in
                print(response.debugDescription)
                debugPrint("\n\n========DATA==========\n\n")
                if let _data = response.data, let utf8Text = String(data: _data, encoding: .utf8) {
                    debugPrint(utf8Text)
                }
                debugPrint("\n\n========DATA==========\n\n")
                completion(APIResponse(result: response.result))
        }
        
        return DefaultAPIRequest(request: dispatchedRequest)
    }
}


