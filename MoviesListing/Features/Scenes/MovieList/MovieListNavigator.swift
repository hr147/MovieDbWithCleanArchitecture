//
//  MovieListNavigator.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 07/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

protocol MovieListNavigator {
    func navigateToDatail(with movie: Movie)
}


class DefaultMovieListNavigator: MovieListNavigator {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToDatail(with movie: Movie) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .movieDetail)
        let movieDetailController: MovieDetailViewController = storyboard.initialViewController()
        
        //View Model create & setup
        movieDetailController.viewModel = MovieDetailViewModel(movie: movie)
        
        //lazy loader create & setup
        movieDetailController.imageLazyLoader = KingfisherLazyImageLoader()
        
        navigationController?.pushViewController(movieDetailController, animated: true)
    }
    
}
