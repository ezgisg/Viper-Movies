//
//  FavoritesPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

// MARK: - FavoritesPresenterProtocol
protocol FavoritesPresenterProtocol: AnyObject {
    var favorites: [MovieFavoriteDetails] { get set }
    var filteredFavorites: [MovieFavoriteDetails] { get set }
    
    func loadData()
    func didSelect(movieId: Int)
    func searchWithText(text: String)
    func deleteFromFavorites(movieId: Int)
}

// MARK: - FavoritesPresenter
final class FavoritesPresenter {
    
    // MARK: - Module Components
    weak var view: FavoritesViewControllerProtocol?
    var interactor: FavoritesInteractorProtocol?
    var router: FavoritesRouterProtocol?
    
    // MARK: - Global Variables
    var favorites: [MovieFavoriteDetails] = []
    var filteredFavorites: [MovieFavoriteDetails] = []
    
    init(view: FavoritesViewControllerProtocol, interactor: FavoritesInteractorProtocol, router: FavoritesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    func loadData() {
        guard let favorites = UserDefaults.standard.object(forKey: Constants.UserDefaults.favorites) as? Data,
              let decoded = try? JSONDecoder().decode([MovieFavoriteDetails].self, from: favorites) else { return }
        self.favorites = decoded
        filteredFavorites = self.favorites
        view?.reloadData()
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
    ///To search in recorded favorites
    func searchWithText(text: String) {
        if text.count == 0 {
            filteredFavorites = favorites
        } else {
            filteredFavorites = favorites.filter {  $0.title?.lowercased().contains(text.lowercased()) ?? false }
        }
        view?.reloadData()
    }
    
    func deleteFromFavorites(movieId: Int) {
        guard let index = favorites.firstIndex(where: { $0.id == movieId }) else { return }
        favorites.remove(at: index)
        if let index = filteredFavorites.firstIndex(where: { $0.id == movieId }) {
            filteredFavorites.remove(at: index)
        }
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.favorites)
        }
    }
}

// MARK: - FavoritesInteractorOutputProtocol
extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
}

