//
//  NetworkManager.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation
import Alamofire


//3. Request Cancelable

struct DefaultAPIRequest: APIRequest {
    let request: DataRequest
    func cancel() {
        request.cancel()
    }
}

struct RequestConverter<T: Encodable> {
    let method: HTTPMethod
    let path: String
    var parameters: T?
    let encoder: Alamofire.ParameterEncoder
}

extension RequestConverter: URLRequestConvertible {
    /// Required method to conform to the `URLRequestConvertible` protocol.
    ///
    /// - Returns: URLRequest object
    /// - Throws: An `Error` if the underlying `URLRequest` is `nil`.
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        let request = try URLRequest(url: url, method: method)
        
        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}


class NetworkManager: Networking {
    
    func get<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        
        let convertedRequest = RequestConverter(method: .get,
                                                path: request.path.url,
                                                parameters: request.parameters,
                                                encoder: URLEncodedFormParameterEncoder.default)
        
        return dispatch(with: convertedRequest, completion: completion)
        
    }
    
    func post<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        let convertedRequest = RequestConverter(method: .post,
                                                path: request.path.url,
                                                parameters: request.parameters,
                                                encoder: URLEncodedFormParameterEncoder.default)
        
        return dispatch(with: convertedRequest, completion: completion)
    }
    
    func put<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        let convertedRequest = RequestConverter(method: .put,
                                                path: request.path.url,
                                                parameters: request.path.url,
                                                encoder: URLEncodedFormParameterEncoder.default)
        
        return dispatch(with: convertedRequest, completion: completion)
    }
    
    
    func dispatch<T: Decodable>(with request: URLRequestConvertible, completion: @escaping Completion<T>) -> APIRequest {
        let dataRequest = AF.request(request)
            .validate()
            .responseDecodable { (response: DataResponse<T>) in
                completion(APIResponse(result: response.result))
        }
        
        return DefaultAPIRequest(request: dataRequest)
    }
}
