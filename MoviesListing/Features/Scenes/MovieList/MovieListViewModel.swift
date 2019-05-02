//
//  MovieListViewModel.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieListViewModel {
    private let moviesUseCase: MoviesUseCase
    private var currentPage: Int = 1
    private var moviesDataSource: [Movie] = []
    
    var numberOfRows: Int {
        return moviesDataSource.count
    }
    
    subscript (movieAtIndex index:Int) -> Movie {
        return moviesDataSource[index]
    }
    
    init(moviesUseCase: MoviesUseCase) {
        self.moviesUseCase = moviesUseCase
    }
    
    private func updateMoviesDataSource(with responseModel: MovieResponseModel) {
        guard let movies = responseModel.movies, !movies.isEmpty else { return }
        
        moviesDataSource += movies
        currentPage += 1
    }
}

extension MovieListViewModel {
    struct Input {
        let viewDidLoad: Signal<Void>
    }
    
    struct Output {
        let reloadTableView: Signal<Void>
        let error: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        //let activityIndicator = ActivityIndicator()
        
        let reloadView =  input.viewDidLoad
            .asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ self.currentPage })
            .distinctUntilChanged()
            .flatMap({
                self.moviesUseCase.getMovies(for: $0)
                .trackError(errorTracker)
            })
            .do(onNext: updateMoviesDataSource)
            .mapToVoid()
            .asSignal(onErrorJustReturn: ())
        
        let errorDriver = errorTracker.asDriver()
        
        return Output(
            reloadTableView: reloadView,
            error: errorDriver)
    }
}
