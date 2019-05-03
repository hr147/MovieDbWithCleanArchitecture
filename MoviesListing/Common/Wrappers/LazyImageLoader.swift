//
//  LazyImageLoader.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 03/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit
import Kingfisher


protocol LazyImageLoader {
    func loadImage(with imageView: UIImageView?, withURL url: String?)
}

struct KingfisherLazyImageLoader: LazyImageLoader {
    func loadImage(with imageView: UIImageView?, withURL url: String?) {
        let placeholderImage = #imageLiteral(resourceName: "placeholder")
        imageView?.image = placeholderImage
        
        guard let stringURL = url else { return }
        
        let resource = URL(string: stringURL)
        imageView?.kf.setImage(with: resource, placeholder: placeholderImage, options: [.transition(.fade(0.25))])
    }
}
