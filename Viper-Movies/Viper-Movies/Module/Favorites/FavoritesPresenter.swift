//
//  FavoritesPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    var favorites: [MovieFavoriteDetails] { get set }
    func loadData()
    
}

final class FavoritesPresenter {
    weak var view: FavoritesViewControllerProtocol?
    var interactor: FavoritesInteractorProtocol?
    var router: FavoritesRouterProtocol?
    var favorites: [MovieFavoriteDetails] = []
    
    init(view: FavoritesViewControllerProtocol, interactor: FavoritesInteractorProtocol, router: FavoritesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func loadData() {
        getFromUserDefaults()
    }

}

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
}

extension FavoritesPresenter {
    private func getFromUserDefaults()  {
        guard let favorites = UserDefaults.standard.object(forKey: "favorites") as? Data,
              let decoded = try? JSONDecoder().decode([MovieFavoriteDetails].self, from: favorites) else { return }
        self.favorites = decoded
        view?.reloadData()
    }
}
