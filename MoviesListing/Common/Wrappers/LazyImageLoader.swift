//
//  LazyImageLoader.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 03/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setLazyImage(with url: String?, withPlaceholder placeholder: UIImage = #imageLiteral(resourceName: "placeholder")) {
        guard let url = url, let resource = URL(string: url) else { return }
        
        kf.setImage(with: resource, placeholder: placeholder, options: [.transition(.fade(0.25))])
    }
}
