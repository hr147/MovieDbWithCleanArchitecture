//
//  MoviesListingTests.swift
//  MoviesListingTests
//
//  Created by Haroon Ur Rasheed on 28/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RxTest

@testable import MoviesListing

extension Movie {
    init(
        originalTitle: String?,
        backdropPath: String?,
        posterPath: String?,
        overview: String?,
        releaseDate: String?
        ) {
        self.init(id: 123,
                  title: nil,
                  voteCount: nil,
                  video: nil,
                  voteAverage: nil,
                  popularity: nil,
                  posterPath: posterPath,
                  originalLanguage: nil,
                  originalTitle: originalTitle,
                  backdropPath: backdropPath,
                  adult: nil,
                  overview: overview,
                  releaseDate: releaseDate,
                  genreIds: nil)
    }
}

class MockMovieUseCase: MoviesUseCase {
    var pageNo = 0
    func getMovies(for page: Int) -> Single<MovieResponseModel> {
        pageNo = page
        let movie1 = Movie(originalTitle: "movie1", backdropPath: "", posterPath: "", overview: "overview1", releaseDate: "12-12-1998")
        let movie2 = Movie(originalTitle: "movie1", backdropPath: "", posterPath: "", overview: "overview1", releaseDate: "12-12-1998")
        let movie3 = Movie(originalTitle: "movie1", backdropPath: "", posterPath: "", overview: "overview1", releaseDate: "12-12-1998")
        let response = MovieResponseModel(page: 1, totalResults: 3, totalPages: 10, movies: [movie1,movie2,movie3])
        
        return .just(response)
    }
    
}


func CreateMovieListViewModelInput(viewDidLoad: Signal<Void> = .empty(),
                                   scrollingDidEnd: Signal<Void> = .empty(),
                                   dateFilterApplied: Signal<Date> = .empty(),
                                   filterDidTap: Signal<Void> = .empty(),
                                   movieDidSelectAtIndex: Driver<Int> = .empty()
    ) -> MovieListViewModel.Input {
    
    return MovieListViewModel.Input(viewDidLoad: viewDidLoad,
                                    scrollingDidEnd: scrollingDidEnd,
                                    dateFilterApplied: dateFilterApplied,
                                    filterDidTap: filterDidTap,
                                    movieDidSelectAtIndex: movieDidSelectAtIndex)
}

class MockMovieListNavigator: MovieListNavigator {
    var isNavigate = false
    func navigateToDatail(with movie: Movie) {
        isNavigate = true
    }
}

class MoviesListingTests: BaseXCTest {
    
    var mockNavigator: MockMovieListNavigator!
    var mockMovieUseCase: MockMovieUseCase!
    var viewModel: MovieListViewModel!
    
    override func setUp() {
        mockNavigator = MockMovieListNavigator()
        mockMovieUseCase = MockMovieUseCase()
        viewModel = MovieListViewModel(moviesUseCase: mockMovieUseCase, navigator: mockNavigator)
    }
    
    override func tearDown() {
       mockNavigator = nil
       mockMovieUseCase = nil
       viewModel = nil
    }
    
    func testReloadTableViewOnViewDidLoad() {
        var isReloaded = false
        var title: String = ""
        var busyIndicatorShown = false
        
        autoreleasepool {
            //let viewmodel = MovieListViewModel(moviesUseCase: MockMovieUseCase(), navigator: MockMovieListNavigator())
            let viewDidLoad = PublishSubject<Void>()
            let input = CreateMovieListViewModelInput(viewDidLoad: viewDidLoad.asSignal(onErrorJustReturn: ()))
            
            
            let output = viewModel.transform(input: input)
            
            _ = output.reloadTableView.emit(onNext: { _ in
                isReloaded = true
            })
            
            _ = output.filterTitle.emit(onNext: { actionTitle in
                title = actionTitle
            })
            
            _ = output.fetching.drive(onNext: { isFetching in
                busyIndicatorShown = true
            })
            
            viewDidLoad.onNext(())
            let movieViewModel: Any = viewModel[movieViewModelAtIndex: 0]
            XCTAssert(viewModel.numberOfRows == 3)
            XCTAssertTrue(movieViewModel is MovieViewModel)
        }
        XCTAssertTrue(isReloaded)
        XCTAssertTrue(title == "Filter")
        XCTAssertTrue(busyIndicatorShown)
    }
    
    func testReloadTableViewOnNextPageTriggered() {
        var isReloaded = false
        
        autoreleasepool {
            let viewDidLoad = PublishSubject<Void>()
            let nextPageSubject = PublishSubject<Void>()
            
            let input = CreateMovieListViewModelInput(viewDidLoad: viewDidLoad.asSignal(onErrorJustReturn: ()),
                                                      scrollingDidEnd: nextPageSubject.asSignal(onErrorJustReturn: ()))
            
            let output = viewModel.transform(input: input)
            
            _ = output.reloadTableView.emit(onNext: { _ in
                isReloaded = true
            })
            
            viewDidLoad.onNext(())
            XCTAssertTrue(mockMovieUseCase.pageNo == 1)
            nextPageSubject.onNext(())
            XCTAssertTrue(mockMovieUseCase.pageNo == 2)
            XCTAssert(viewModel.numberOfRows == 6)
        }
        XCTAssertTrue(isReloaded)
    }
    
    func testShowDatePickerOnFilterAction() {
        var isDatePickerShown = false
        
        autoreleasepool {
            let filterAction = PublishSubject<Void>()
            let input = CreateMovieListViewModelInput(filterDidTap: filterAction.asSignal(onErrorJustReturn: ()))
            
            let output = viewModel.transform(input: input)
            
            
            _ = output.showDatePicker.emit(onNext: { _ in
                isDatePickerShown = true
            })
            
            filterAction.onNext(())
            
        }
        XCTAssertTrue(isDatePickerShown)
    }
    
    func testFilterForDateSelectionAndResetAction() {
        var isDatePickerShown = false
        var actionTitle: String = ""
        
        autoreleasepool {
            let dateAction = PublishSubject<Date>()
            let viewDidLoad = PublishSubject<Void>()
            let tapAction = PublishSubject<Void>()
            let input = CreateMovieListViewModelInput(
                viewDidLoad: viewDidLoad.asSignal(onErrorJustReturn: ()),
                dateFilterApplied: dateAction.asSignal(onErrorJustReturn: Date()),
                filterDidTap: tapAction.asSignal(onErrorJustReturn: ())
            )
            
            let output = viewModel.transform(input: input)
            
            
            _ = output.showDatePicker.emit(onNext: { _ in
                isDatePickerShown = true
            })
            
            _ = output.filterTitle.emit(onNext: { title in
                actionTitle = title
            })
            
            _ = output.reloadTableView.emit()
            
            viewDidLoad.onNext(())
            XCTAssertTrue(viewModel.numberOfRows == 3)
            
            //filter applied
            dateAction.onNext(Date())
            XCTAssertTrue(actionTitle == "Reset")
            XCTAssertTrue(viewModel.numberOfRows == 0)
            
            //reset filter performed
            tapAction.onNext(())
            XCTAssertTrue(actionTitle == "Filter")
        }
        XCTAssertFalse(isDatePickerShown)
    }
    
    func testNavigateToDetailScreenOnRowSelection() {
        
        autoreleasepool {
            let viewDidLoad = PublishSubject<Void>()
            let cellDidSelectAtRow = PublishSubject<Int>()
            
            let input = CreateMovieListViewModelInput(
                viewDidLoad: viewDidLoad.asSignal(onErrorJustReturn: ()),
                movieDidSelectAtIndex: cellDidSelectAtRow.asDriverOnErrorJustComplete())
            
            let output = viewModel.transform(input: input)
            
            
            _ = output.reloadTableView.emit()
            _ = output.movieDidSelect.drive()
            
            viewDidLoad.onNext(())
            cellDidSelectAtRow.onNext(0)
            
            XCTAssertTrue(mockNavigator.isNavigate)
            
        }
        
    }
}
