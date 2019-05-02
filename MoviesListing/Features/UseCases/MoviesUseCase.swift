//
//  MoviesUseCase.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import RxSwift

protocol MoviesUseCase {
    func getMovies(for page: Int)
}

final class DefaultMoviesUseCase {
    let apiDispatcher: APIDispatching
    
    init(apiDispatcher: APIDispatching = NetworkManager.shared) {
        self.apiDispatcher = apiDispatcher
    }
}

extension DefaultMoviesUseCase: MoviesUseCase {
    func getMovies(for page: Int) {
        let router = APIRouter.Movie.get(parameters: nil as Int?)
    }
}
