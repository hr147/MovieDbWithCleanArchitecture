//
//  MovieTableViewCell.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private func setupUI() {
        posterImageView?.layer.cornerRadius = 4.0
        ratingLabel?.layer.masksToBounds = true
        ratingLabel?.layer.cornerRadius = 20.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
