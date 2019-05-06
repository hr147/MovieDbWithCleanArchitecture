//
//  Networking.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

//1. Define entire app endpoints and envirment
struct APIPathBuilder {
    let url: String
    
    init(baseURL: BaseURL = .enivirnemnt(.production), endPoint: EndPoint) {
        self.url = baseURL.url + endPoint.rawValue
    }
    
    enum Envirnment: String {
        case production = "http://api.themoviedb.org/3/"
    }
    
    enum EndPoint: String {
        case movie = "movie/now_playing"
    }
    
    enum BaseURL {
        case custom(String)
        case enivirnemnt(Envirnment)
        
        var url: String {
            switch self {
            case .custom(let value): return value
            case .enivirnemnt(let enriment): return enriment.rawValue
            }
        }
    }
}

//2. Request Builder
struct RequestBuilder<Parameter: Encodable> {
    let path: APIPathBuilder
    let parameters: Parameter
    let headers: [String: String]? = nil
}

//3. API Response
struct APIResponse<T> {
    let result: Result<T, Error>
}

//4. Cancelable Request
protocol APIRequest {
    func cancel()
}

//5. Perferm API request using differnt restful methods
protocol Networking {
    typealias Completion<T> = (APIResponse<T>) -> Void
    
    @discardableResult
    func get<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest
    
    func post<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest
    
    func put<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest
}
