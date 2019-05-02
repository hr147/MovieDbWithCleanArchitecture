//
//  MovieResponseModel.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

struct MovieResponseModel: Decodable {
    let page: Int?
    let totalResults: Int64?
    let totalPages: Int64?
    let movies: [Movie]?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
