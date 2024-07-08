//
//  FavoritesInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

// MARK: - FavoritesInteractorProtocol
protocol FavoritesInteractorProtocol: AnyObject {
}

// MARK: - FavoritesInteractorOutputProtocol
protocol FavoritesInteractorOutputProtocol: AnyObject {
}

// MARK: - FavoritesInteractor
final class FavoritesInteractor {
    var presenter: FavoritesPresenterProtocol?
    var output: FavoritesInteractorOutputProtocol?
}

// MARK: - FavoritesInteractorProtocol
extension FavoritesInteractor: FavoritesInteractorProtocol {
}
