//
//  MovieListViewController.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class MovieListViewController: UITableViewController {
    //UI Properties
    @IBOutlet weak var nextPageActivityIndicatorView: UIActivityIndicatorView!
    private lazy var filterBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return button
    }()
    
    //Injected Properties
    var viewModel: MovieListViewModel!
    var imageLazyLoader: LazyImageLoader!
    
    //Private Properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let scrollToEndSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private lazy var datePickerViewer = DatePickerPresenter()
    
    //MARK: - Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        //emit signal on viewDidLoad triggered
        viewDidLoadSubject.onNext(())
    }
    
    //MARK: - Actions Methods
    
    func showDatePicker() {
        datePickerViewer.present(into: view)
    }
    
    //MARK: - Private Methods
    
    private func setupUI() {
        title = "Movies"
        navigationItem.rightBarButtonItem = filterBarButton
    }
    
    
    
    private func bindViewModel() {
        //setup input for View
        let input = MovieListViewModel.Input(
            viewDidLoad: viewDidLoadSubject.asSignal(onErrorJustReturn: ()),
            scrollingDidEnd: scrollToEndSubject.asSignal(onErrorJustReturn: ()),
            dateFilterApplied: datePickerViewer.dateDidSelectSubject.asSignal(onErrorJustReturn: Date()),
            filterDidTap: filterBarButton.rx.tap.asSignal())
        
        //transform input to output
        let output = viewModel.transform(input: input)
        
        //setup Output to View
        [output.reloadTableView.emit(onNext: tableView.reloadData),
         output.fetching.drive(nextPageActivityIndicatorView.rx.isAnimating),
         output.filterTitle.emit(to: filterBarButton.rx.title),
         output.showDatePicker.emit(onNext: showDatePicker),
         output.error.drive(onNext: UIAlertController.showAlert)]
            .forEach({ $0.disposed(by: disposeBag) })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        //Get view model for cell
        let cellViewModel = viewModel[movieViewModelAtIndex: indexPath.row]
        imageLazyLoader.loadImage(with: cell.posterImageView, withURL: cellViewModel.imageURL)
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastRow = indexPath.row == viewModel.numberOfRows - 1
        
        if isLastRow {
            scrollToEndSubject.onNext(())
        }
    }
}
