//
//  MoviesUseCase.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import RxSwift

protocol MoviesUseCase {
    func getMovies(for page: Int) -> Single<MovieResponseModel>
}

final class DefaultMoviesUseCase {
    let networking: Networking
    
    init(networking: Networking = NetworkManager()) {
        self.networking = networking
    }
}

extension DefaultMoviesUseCase: MoviesUseCase {
    
    func getMovies(for page: Int) -> Single<MovieResponseModel> {
        print("Next Request Hit==================>>>>>>>>>>>>>for page \(page)")
        return .create(subscribe: { single -> Disposable in
            let parameters = MovieRequestModel(page: page, api_key: Constants.Keys.api)
            let request = RequestBuilder(path: .init(endPoint: .movie), parameters: parameters)
            
            let task = self.networking.get(request: request, completion: { (response: APIResponse<MovieResponseModel>) in
                switch response.result {
                case .failure(let error): single(.error(error))
                case .success(let value): single(.success(value))
                }
            })
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
