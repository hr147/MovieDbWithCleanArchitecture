//
//  MovieDetailsTests.swift
//  MoviesListingTests
//
//  Created by Haroon Ur Rasheed on 09/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MoviesListing

class MovieDetailsTests: XCTestCase {
    
    func testMovieDetailInformation() {
        
        //GIVEN
        let screenTitle = BehaviorRelay<String>(value: "")
        let backgroundURL = BehaviorRelay<String>(value: "")
        let posterURL = BehaviorRelay<String>(value: "")
        let movieTitle = BehaviorRelay<String>(value: "")
        let rating = BehaviorRelay<String>(value: "")
        let releaseDate = BehaviorRelay<String>(value: "")
        let language = BehaviorRelay<String>(value: "")
        let overview = BehaviorRelay<String>(value: "")
        
        autoreleasepool {
            let movie = Movie(originalTitle: "Hitman",
                              backdropPath: "/hitmanbackimage.png",
                              posterPath: "/hitmanposterimage.png",
                              overview: "hitman is good movie",
                              releaseDate: "24-3-1988")
            let viewModel = MovieDetailViewModel(movie: movie)
            
            let viewwillappeared = PublishSubject<Void>()
            
            let input = MovieDetailViewModel.Input(viewWillAppearTriggered: viewwillappeared.asSignal(onErrorJustReturn: ()))
            
            let output = viewModel.transform(input: input)
            
            _ = output.screenTitle.emit(to: screenTitle)
            _ = output.backgroundURL.emit(to: backgroundURL)
            _ = output.posterURL.emit(to: posterURL)
            _ = output.movieTitle.emit(to: movieTitle)
            _ = output.rating.emit(to: rating)
            _ = output.releaseDate.emit(to: releaseDate)
            _ = output.language.emit(to: language)
            _ = output.overview.emit(to: overview)
            
            //WHEN
            viewwillappeared.onNext(())
        }
        
        //THEN
        XCTAssertTrue(screenTitle.value == "Details")
        XCTAssertTrue(backgroundURL.value == "http://image.tmdb.org/t/p/w500/hitmanbackimage.png")
        XCTAssertTrue(posterURL.value == "http://image.tmdb.org/t/p/w92/hitmanposterimage.png")
        XCTAssertTrue(rating.value == "0.0 / 10")
        XCTAssertTrue(releaseDate.value == "24-3-1988")
    }
}
