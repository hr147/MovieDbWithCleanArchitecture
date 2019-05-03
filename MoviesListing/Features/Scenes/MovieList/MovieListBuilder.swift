//
//  MovieListBuilder.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

struct MovieListBuilder {

    static func build() -> MovieListViewController {
        let storyboard = UIStoryboard(storyboard: .movieList)
        let controller: MovieListViewController = storyboard.initialViewController()
        controller.viewModel = MovieListViewModel(moviesUseCase: DefaultMoviesUseCase())
        controller.imageLazyLoader = KingfisherLazyImageLoader()
        return controller
    }
}
