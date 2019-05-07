//
//  AppNavigator.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

class AppNavigator {
    
    func installRoot(into window: UIWindow?) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .movieList)
        let movieListController: MovieListViewController = storyboard.initialViewController()
        let rootController = AppNavigationController(rootViewController: movieListController)
        
        //View Model create & setup
        movieListController.viewModel = MovieListViewModel(
            moviesUseCase: DefaultMoviesUseCase(),
            navigator: DefaultMovieListNavigator(navigationController: rootController))
        
        //lazy loader create & setup
        movieListController.imageLazyLoader = KingfisherLazyImageLoader()
        
        window?.rootViewController = rootController
    }
}
