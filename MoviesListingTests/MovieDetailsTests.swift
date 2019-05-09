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

/*
 
 struct Output {
 let screenTitle: Signal<String>
 let backgroundURL: Signal<String>
 let posterURL: Signal<String>
 let movieTitle: Signal<String>
 let rating: Signal<String>
 let releaseDate: Signal<String>
 let language: Signal<String>
 let overview: Signal<String>
 }
 
 
 let title = input.viewWillAppearTriggered.map({ "Details" })
 
 let backgroundURL = movieSignal
 .filter({ $0.backdropPath != nil })
 .map({ $0.backdropPath! })
 .map({ Constants.API.imageBaseURL(imageSize: .large) + $0 })
 
 let posterURL = movieSignal
 .filter({ $0.posterPath != nil })
 .map({ $0.posterPath! })
 .map({ Constants.API.imageBaseURL(imageSize: .thumb) + $0 })
 
 let movieTitle = movieSignal
 .map({ $0.originalTitle ?? "" })
 
 let rating = movieSignal
 .map({ String($0.voteAverage ?? 0.0) + " / 10" })
 
 let releaseDate = movieSignal
 .map({ $0.releaseDate ?? "not found"})
 
 let language = movieSignal
 .map({ $0.originalLanguage ?? "not found"})
 
 let overview = movieSignal
 .map({ $0.overview ?? "Sorry there is no overview of this film."})
 
 */
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
        
        //THEN
        XCTAssertTrue(screenTitle.value == "Details")
        XCTAssertTrue(backgroundURL.value == "http://image.tmdb.org/t/p/w500/hitmanbackimage.png")
        XCTAssertTrue(posterURL.value == "http://image.tmdb.org/t/p/w92/hitmanposterimage.png")
        
    }
}
