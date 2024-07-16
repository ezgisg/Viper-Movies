//
//  FavoritesViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import UIKit

// MARK: - FavoritesViewControllerProtocol
protocol FavoritesViewControllerProtocol: AnyObject {
    func reloadData()
}

// MARK: - FavoritesViewController
final class FavoritesViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mainEmptyView: EmptyView!
    @IBOutlet private weak var searchEmptyView: EmptyView!
    
    // MARK: - Variables
    private var emptyView: EmptyView?
    private var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Module Components
    var presenter: FavoritesPresenterProtocol?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupEmptyViews()
        checkForEmptyViews()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadData()
        guard let searchText = searchBar.text,
              !searchText.isEmpty else { return }
        presenter?.searchWithText(text: searchText)
    }
}

// MARK: - FavoritesViewControllerProtocol
extension FavoritesViewController: FavoritesViewControllerProtocol {
    func reloadData() {
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
        checkForEmptyViews()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.filteredFavorites.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FavoritesTableViewCell.self)
        if let favorite = presenter?.filteredFavorites[safe: indexPath.row] {
            cell.configure(with: favorite)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieID = presenter?.filteredFavorites[indexPath.row].id else { return }
        presenter?.didSelect(movieId: movieID)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let movieID = presenter?.filteredFavorites[indexPath.row].id else { return }
        presenter?.deleteFromFavorites(movieId: movieID)
        
        DispatchQueue.main.async {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
        checkForEmptyViews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UISearchBarDelegate
extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchWithText(text: searchText)
    }
}

// MARK: - Setups
private extension FavoritesViewController {
    final func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: FavoritesTableViewCell.self)
    }

    ///To manage "main empty view" and "search empty view" show-hide status
    final func checkForEmptyViews() {
        let isItemExist = !(presenter?.filteredFavorites.isEmpty ?? true)
        let isSearchBarActive = (searchBar.text?.count ?? 0) != 0
        
        let isSearchEmptyViewActive = !isItemExist && isSearchBarActive
        let isMainEmptyViewActive = !isItemExist && !isSearchBarActive
        
        tableView.isHidden = !isItemExist
    
        setupSearchEmptyView(isActive: isSearchEmptyViewActive)
        setupMainEmptyView(isActive: isMainEmptyViewActive)
    }
    
    final func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = L10n.SearchInput.search.localized()
    }
    
    final func setupMainEmptyView(isActive: Bool) {
        mainEmptyView.isHidden = !isActive
        searchEmptyView.isHidden = isActive
    }
    
    final func setupSearchEmptyView(isActive: Bool) {
        mainEmptyView.isHidden = isActive
        searchEmptyView.isHidden = !isActive
    }
    
    /// Initial setups
    final func setupEmptyViews() {
        mainEmptyView.addImage.image = UIImage(named: "addFavorite")
        mainEmptyView.addText.text = L10n.letsAdd.localized()
        mainEmptyView.noMoviesText.text = L10n.noMoviesToList.localized()
        
        searchEmptyView.addImage.isHidden = true
        searchEmptyView.addText.isHidden = true
        searchEmptyView.noMoviesText.text = L10n.noResult.localized()
    }
}



