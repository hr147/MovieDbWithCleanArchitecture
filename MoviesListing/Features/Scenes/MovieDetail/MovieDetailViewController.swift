//
//  MovieDetailViewController.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    //Injected Properties
    var viewModel: MovieDetailViewModel!
    
    //Private Properties
    private let disposeBag = DisposeBag()
    
    //MARK: - Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    deinit {
        print(String(describing: self) + "deinit \n")
    }
    
    //MARK: - Private Methods
    
    private func bindViewModel() {
        //setup input for View
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asSignal(onErrorJustReturn: ())
        
        let input = MovieDetailViewModel.Input(viewWillAppearTriggered: viewWillAppear)

        //transform input to output
        let output = viewModel.transform(input: input)
        
        //setup Output to View
        [output.screenTitle.emit(to: rx.title),
         output.backgroundURL.emit(onNext: { [weak self] in
            self?.backgroundImageView.setLazyImage(with: $0)
         }),
         output.posterURL.emit(onNext: { [weak self] in
            self?.posterImageView.setLazyImage(with: $0)
         }),
         output.movieTitle.emit(to: titleLabel.rx.text),
         output.rating.emit(to: ratingLabel.rx.text),
         output.releaseDate.emit(to: releaseDateLabel.rx.text),
         output.language.emit(to: languageLabel.rx.text),
         output.overview.emit(to: overviewLabel.rx.text)
            ]
            .forEach({ $0.disposed(by: disposeBag) })
    }
}
