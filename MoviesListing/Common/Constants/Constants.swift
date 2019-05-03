//
//  Constants.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let api = "2696829a81b1b5827d515ff121700838"
    }
    
    struct API {
        static let baseURL  = "http://api.themoviedb.org/3/"
        
        enum ImageSize: Int {
            case thumb = 92
            case large = 500
        }
        
        static func imageBaseURL(imageSize: ImageSize = .thumb) -> String {
            return "http://image.tmdb.org/t/p/w\(imageSize.rawValue)"
        }
    }
}
