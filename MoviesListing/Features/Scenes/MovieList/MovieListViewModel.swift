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
    private let navigator: MovieListNavigator
    private var currentPage: Int = 1
    private var moviesDataSource: [Movie] = []
    private var filteredMoviesDataSource: [Movie] = []
    private var isFilterActivated = false
    
    private var activeDateSource: [Movie] {
        if isFilterActivated {
            return filteredMoviesDataSource
        }
        return moviesDataSource
    }
    
    var numberOfRows: Int {
        return activeDateSource.count
    }
    
    subscript (movieViewModelAtIndex index: Int) -> MovieViewModel {
        return MovieViewModel(movie: activeDateSource[index])
    }
    
    init(moviesUseCase: MoviesUseCase, navigator: MovieListNavigator) {
        self.moviesUseCase = moviesUseCase
        self.navigator = navigator
    }
    
    private func updateMoviesDataSource(with responseModel: MovieResponseModel) {
        guard let movies = responseModel.movies, !movies.isEmpty else { return }
    
        moviesDataSource += movies
        currentPage += 1
    }
    
    private func activateFilterOnDateSource(with date: Date) {
        filteredMoviesDataSource = moviesDataSource.filter({ $0.releaseDate == date.string() })
        isFilterActivated = true
    }
    
    private func clearFilterOnDateSource() {
        filteredMoviesDataSource.removeAll()
        isFilterActivated = false
    }
}

extension MovieListViewModel {
    struct Input {
        let viewDidLoad: Signal<Void>
        let scrollingDidEnd: Signal<Void>
        let dateFilterApplied: Signal<Date>
        let filterDidTap: Signal<Void>
        let movieDidSelectAtIndex: Driver<Int>
    }
    
    struct Output {
        let reloadTableView: Signal<Void>
        let error: Driver<Error>
        let fetching: Driver<Bool>
        let filterTitle: Signal<String>
        let showDatePicker: Signal<Void>
        let movieDidSelect: Driver<Void>
    }
    
    enum Action {
        case reload
        case showPicker
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let nextPageLoad = input.scrollingDidEnd
            .asObservable()
            .withLatestFrom(activityIndicator)
            .filter({ $0 == false && self.isFilterActivated == false })
            .mapToVoid()
        
        
        let serverResult =  Observable.merge(input.viewDidLoad.asObservable(),nextPageLoad)
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
        
        
        let filterResult = input.dateFilterApplied
            .asObservable()
            .do(onNext: activateFilterOnDateSource)
            .mapToVoid()
            .asSignal(onErrorJustReturn: ())
        
        let filterActionTriggered = input.filterDidTap
            .flatMap({ _ -> Signal<Action> in
                return self.isFilterActivated ? .just(.reload) : .just(.showPicker)
            })
        
        let reloadOnClearFilter = filterActionTriggered
            .filter({ $0 == .reload })
            .mapToVoid()
            .do(onNext: clearFilterOnDateSource)
        
        
        let showDatePicker = filterActionTriggered
            .filter({ $0 == .showPicker })
            .mapToVoid()
        
        let filterActionTitle = Signal.merge(input.viewDidLoad, filterResult, reloadOnClearFilter)
            .map({ self.isFilterActivated ? "Reset" : "Filter" })
        
        let movieDidSelect = input.movieDidSelectAtIndex
                            .map({ self.activeDateSource[$0] })
                            .do(onNext: navigator.navigateToDatail)
                            .mapToVoid()
        
        let relaodTableView = Signal.merge(serverResult, filterResult, reloadOnClearFilter)
        let errorDriver = errorTracker.asDriver()
        let fetchingDriver = activityIndicator.asDriver()
        
        return Output(
            reloadTableView: relaodTableView,
            error: errorDriver,
            fetching: fetchingDriver,
            filterTitle: filterActionTitle,
            showDatePicker: showDatePicker,
            movieDidSelect: movieDidSelect)
    }
}
