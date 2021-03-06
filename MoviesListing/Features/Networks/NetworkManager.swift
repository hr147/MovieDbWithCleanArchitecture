//
//  NetworkManager.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation
import Alamofire

struct DefaultAPIRequest: APIRequest {
    let request: DataRequest
    func cancel() {
        request.cancel()
    }
}

class NetworkManager: Networking {
    
    func get<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        
        return dispatch(url: request.path.url,
                        method: .get,
                        parameters: request.parameters,
                        encoder: URLEncodedFormParameterEncoder.default,
                        headers: request.headers,
                        completion: completion)
        
    }
    
    func post<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        
        return dispatch(url: request.path.url,
                        method: .post,
                        parameters: request.parameters,
                        encoder: URLEncodedFormParameterEncoder.default,
                        headers: request.headers,
                        completion: completion)
    }
    
    func put<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {
        
        return dispatch(url: request.path.url,
                        method: .put,
                        parameters: request.parameters,
                        encoder: URLEncodedFormParameterEncoder.default,
                        headers: request.headers,
                        completion: completion)
    }
    
    
    func dispatch<T: Decodable, R: Encodable>(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: R?,
        encoder: ParameterEncoder,
        headers: [String: String]?,
        completion: @escaping Completion<T>) -> APIRequest {
        
        let headers: HTTPHeaders? = headers.map({ HTTPHeaders($0) })
        
        let dataRequest = AF.request(url, method: method,
                                     parameters: parameters,
                                     encoder: encoder,
                                     headers: headers)
            .validate()
            .responseDecodable { (dataResponse: DataResponse<T, AFError>) in
                switch dataResponse.result {
                case .failure(let error): completion(.init(result: .failure(error)))
                case .success(let decodableObject): completion(.init(result: .success(decodableObject)))
                }
        }
        
        return DefaultAPIRequest(request: dataRequest)
    }
}
