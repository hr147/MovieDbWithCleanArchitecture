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
    
    subscript (movieViewModelAtIndex index: Int) -> MovieViewModel {
        return MovieViewModel(movie: moviesDataSource[index])
    }
    
    init(moviesUseCase: MoviesUseCase) {
        self.moviesUseCase = moviesUseCase
    }
    
    private func updateMoviesDataSource(with responseModel: MovieResponseModel) {
        guard let movies = responseModel.movies, !movies.isEmpty else { return }
        
        print("========Page \(currentPage) is Loaded======")
        moviesDataSource += movies
        currentPage += 1
    }
}

extension MovieListViewModel {
    struct Input {
        let viewDidLoad: Signal<Void>
        let scrollingDidEnd: Signal<Void>
    }
    
    struct Output {
        let reloadTableView: Signal<Void>
        let error: Driver<Error>
        let fetching: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let nextPageLoad = input.scrollingDidEnd
            .asObservable()
            .withLatestFrom(activityIndicator)
            .filter({ $0 == false })
            .mapToVoid()
        
        let reloadView =  Observable.merge(input.viewDidLoad.asObservable(),nextPageLoad)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ self.currentPage })
            .flatMap({
                self.moviesUseCase.getMovies(for: $0)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
            })
            .do(onNext: updateMoviesDataSource)
            .mapToVoid()
            .debug()
            .asSignal(onErrorJustReturn: ())
        
        let errorDriver = errorTracker.asDriver()
        let fetchingDriver = activityIndicator.asDriver()
        
        return Output(
            reloadTableView: reloadView,
            error: errorDriver,
            fetching: fetchingDriver)
    }
}
