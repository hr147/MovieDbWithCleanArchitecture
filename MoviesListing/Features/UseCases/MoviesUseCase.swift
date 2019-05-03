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
    let apiDispatcher: APIDispatching
    
    init(apiDispatcher: APIDispatching = NetworkManager.shared) {
        self.apiDispatcher = apiDispatcher
    }
}

extension DefaultMoviesUseCase: MoviesUseCase {
    
    func getMovies(for page: Int) -> Single<MovieResponseModel> {
        print("Next Request Hit==================>>>>>>>>>>>>>for page \(page)")
        
        return .create(subscribe: { single -> Disposable in
            let parameters = MovieRequestModel(page: page, api_key: Constants.Keys.api)
            //Request configure with parameters
            let router = APIRouter.Movie.get(parameters: parameters)
            
            //Dispatch request
            let task = self.apiDispatcher.dispatch(with: router) { (response: APIResponse<MovieResponseModel>) in
                switch response.result {
                case .failure(let error): single(.error(error))
                case .success(let value): single(.success(value))
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
