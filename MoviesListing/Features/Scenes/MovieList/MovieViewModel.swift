//
//  MovieViewModel.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 03/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

struct MovieViewModel {
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.originalTitle ?? ""
    }
    
    var releaseDate: String {
        let releaseDate = "Release Date: \(movie.releaseDate ?? "not found")"
        return releaseDate
    }
    
    var imageURL: String? {
        guard let posterPath = movie.posterPath else { return nil }
        return Constants.API.imageBaseURL() + posterPath
    }
    
    var overview: String {
        return movie.overview ?? ""
    }
    
    var rating: String {
        return "\(movie.voteAverage ?? 1.0)"
    }
    
}
