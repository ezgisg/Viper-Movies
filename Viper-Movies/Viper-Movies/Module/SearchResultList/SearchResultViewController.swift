//
//  SearchResultViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import UIKit

// MARK: - SearchResultViewControllerProtocol
protocol SearchResultViewControllerProtocol: BaseViewControllerProtocol {
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - SearchResultViewController
class SearchResultViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: SearchResultPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - SearchResultViewControllerProtocol
extension SearchResultViewController: SearchResultViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getMovies().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SearchCell.self)
        let movie = presenter?.getMovies()[indexPath.row]
        if let movie {
            cell.configure(with: movie)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieId = presenter?.getMovies()[indexPath.row].id else { return }
        presenter?.didSelect(movieId: movieId)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if presenter?.getMovies().count == indexPath.row + 1 {
            presenter?.loadMore()
        }
    }
}

// MARK: - Setup Functions
private extension SearchResultViewController {
    final func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SearchCell.self)
    }
}
