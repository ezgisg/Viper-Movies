//
//  FavoritesCellPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

// MARK: - FavoritesCellPresenterProtocol
protocol FavoritesCellPresenterProtocol: AnyObject {
    func load()
}

// MARK: - FavoritesCellPresenter
final class FavoritesCellPresenter {
    let view: FavoritesTableViewCellProtocol?
    private var favorite: MovieFavoriteDetails
    
    init(view: FavoritesTableViewCellProtocol?, favorite: MovieFavoriteDetails) {
        self.view = view
        self.favorite = favorite
    }
}

// MARK: - FavoritesCellPresenterProtocol
extension FavoritesCellPresenter: FavoritesCellPresenterProtocol {
    func load() {
        view?.setNameTitle(title: favorite.title ?? "")
        guard let path = favorite.backdrop_path else {
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(Constants.URLPaths.imageBase)\(path)"
        view?.setImage(imagePath: fullUrl)
    }
}
