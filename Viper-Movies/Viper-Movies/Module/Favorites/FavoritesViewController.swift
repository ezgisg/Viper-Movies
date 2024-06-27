//
//  FavoritesViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import UIKit

protocol FavoritesViewControllerProtocol: AnyObject {
    func reloadData()
  
}

class FavoritesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavoritesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadData()
        setupTableView()
    }
    
}

extension FavoritesViewController: FavoritesViewControllerProtocol {

    
    func reloadData() {
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.favorites.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FavoritesTableViewCell.self)
        if let favorite = presenter?.favorites[indexPath.row] {
            cell.configure(with: favorite)
        }
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
}


extension FavoritesViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: FavoritesTableViewCell.self)
    }
}
