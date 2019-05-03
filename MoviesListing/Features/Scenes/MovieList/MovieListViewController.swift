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
    var viewModel: MovieListViewModel!
    var imageLazyLoader: LazyImageLoader!
    
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        //emit signal on viewDidLoad triggered
        viewDidLoadSubject.onNext(())
    }
    
    private func setupUI() {
        title = "Movies"
    }
    
    private func bindViewModel() {
        //setup input for View
        let input = MovieListViewModel.Input(
            viewDidLoad: viewDidLoadSubject.asSignal(onErrorJustReturn: ()))
        
        //transform input to output
        let output = viewModel.transform(input: input)
        
        //setup Output to View
        [output.reloadTableView.emit(onNext: tableView.reloadData),
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
