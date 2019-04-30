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
        let movieListController = MovieListBuilder.build()
        window?.rootViewController = AppNavigationController(rootViewController: movieListController)
    }
}
