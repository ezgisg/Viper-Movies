//
//  FavoritesCellPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

protocol FavoritesCellPresenterProtocol: AnyObject {
    func load()
}

final class FavoritesCellPresenter {
    
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
    let view: FavoritesTableViewCellProtocol?
    private var favorite: MovieFavoriteDetails
    
    init(view: FavoritesTableViewCellProtocol?, favorite: MovieFavoriteDetails) {
        self.view = view
        self.favorite = favorite
    }
}

extension FavoritesCellPresenter: FavoritesCellPresenterProtocol {
    func load() {
        view?.setNameTitle(title: favorite.title ?? "")
        guard let path = favorite.backdrop_path else {
            view?.setImage(imageUrlString: "")
            return }
        let fullUrl = "\(FavoritesCellPresenter.imageBaseUrl)\(path)"
        view?.setImage(imageUrlString: fullUrl)
    }
}
