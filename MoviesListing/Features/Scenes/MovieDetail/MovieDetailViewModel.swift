//
//  MovieDetailViewModel.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 07/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import RxSwift
import RxCocoa

class MovieDetailViewModel {
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
}

extension MovieDetailViewModel {
    struct Input {
        let viewWillAppearTriggered: Signal<Void>
    }
    
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
    
    func transform(input: Input) -> Output {
        
        let movieSignal = input.viewWillAppearTriggered
            .map({ self.movie })
        
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
        
        return Output(screenTitle: title,
                      backgroundURL: backgroundURL,
                      posterURL: posterURL,
                      movieTitle: movieTitle,
                      rating: rating,
                      releaseDate: releaseDate,
                      language: language,
                      overview: overview)
    }
}
