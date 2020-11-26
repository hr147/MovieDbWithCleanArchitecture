//
//  Movie.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 02/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    
    let id: Int64
    let title: String?
    let voteCount: Int64?
    let video: Bool?
    let voteAverage: Double?
    let popularity: Double?
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String?
    let backdropPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIds: [Int]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
    
}
