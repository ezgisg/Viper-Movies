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
    @IBOutlet weak var mainEmptyView: EmptyView!
    @IBOutlet weak var searchEmptyView: EmptyView!
    private var emptyView: EmptyView?
    private var tapGesture: UITapGestureRecognizer!
    
    var presenter: FavoritesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupEmptyViews()
        checkForEmptyViews()
        setupKeyboardObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter?.loadData()
        if let searchText = searchBar.text,
           !searchText.isEmpty {
            presenter?.searchWithText(text: searchText)
        }
    }
    
}

//MARK: FavoritesViewControllerProtocol
extension FavoritesViewController: FavoritesViewControllerProtocol {

    func reloadData() {
        tableView.reloadData()
        checkForEmptyViews()
    }
}

//MARK: UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.filteredFavorites.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FavoritesTableViewCell.self)
        if let favorite = presenter?.filteredFavorites[indexPath.row] {
            cell.configure(with: favorite)
        }
        return cell
    }
}

//MARK: UITableViewDelegate
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
}

//MARK: UISearchBarDelegate
extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchWithText(text: searchText)
    }
}

private extension FavoritesViewController {
    final func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: FavoritesTableViewCell.self)
    }

    final func checkForEmptyViews() {
        let isItemExist = !(presenter?.filteredFavorites.isEmpty ?? true)
        let isSearchBarActive = (searchBar.text?.count ?? 0) != 0
        
        let isSearchEmptyViewActive = !isItemExist && isSearchBarActive
        let isMainEmptyViewActive = !isItemExist && !isSearchBarActive
        
        tableView.isHidden = !isItemExist
        
        setupMainEmptyView(isActive: isMainEmptyViewActive)
        setupSearchEmptyView(isActive: isSearchEmptyViewActive)
    }
    
    final func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
    }
    
    final func setupMainEmptyView(isActive: Bool) {
        mainEmptyView.isHidden = !isActive
        searchEmptyView.isHidden = isActive
    }
    
    final func setupSearchEmptyView(isActive: Bool) {
        mainEmptyView.isHidden = isActive
        searchEmptyView.isHidden = !isActive
    }
    
    final func setupEmptyViews() {
        mainEmptyView.addImage.image = UIImage(named: "addFavorite")
        mainEmptyView.addText.text = "Let's add!"
        mainEmptyView.noMoviesText.text = "No movies to list"
        searchEmptyView.addImage.isHidden = true
        searchEmptyView.addText.isHidden = true
        searchEmptyView.noMoviesText.text = "No result"
    }
}

//MARK: Keyboard operations
private extension FavoritesViewController {
    
    private func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      }

      @objc private func keyboardWillShow() {
          if tapGesture == nil {
              tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          }
          view.addGestureRecognizer(tapGesture)
      }
      
      @objc private func keyboardWillHide() {
          if tapGesture != nil {
              view.removeGestureRecognizer(tapGesture)
          }
      }
      
      @objc private func dismissKeyboard() {
          view.endEditing(true)
      }
}

