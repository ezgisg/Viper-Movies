//
//  FavoritesInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

protocol FavoritesInteractorProtocol: AnyObject {
    
}

protocol FavoritesInteractorOutputProtocol: AnyObject {
    
}

final class FavoritesInteractor {
    var presenter: FavoritesPresenterProtocol?
    var output: FavoritesInteractorOutputProtocol?
}

extension FavoritesInteractor: FavoritesInteractorProtocol {
    
}
