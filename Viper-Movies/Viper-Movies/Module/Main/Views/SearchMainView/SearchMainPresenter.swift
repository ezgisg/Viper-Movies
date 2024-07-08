//
//  SearchMainPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 8.07.2024.
//

import Foundation

// MARK: - SearchMainPresenterProtocol
protocol SearchMainPresenterProtocol: AnyObject {
    func load()
}

// MARK: - SearchMainPresenter
final class SearchMainPresenter {
    weak var view: SearchMainViewProtocol?
    private var movies: [MovResult] = []
    
    init(view: SearchMainViewProtocol, movies: [MovResult]) {
        self.view = view
        self.movies = movies
    }
}

// MARK: - SearchMainPresenterProtocol
extension SearchMainPresenter: SearchMainPresenterProtocol {
    func load() {
        view?.movies = movies
        view?.reloadData()
    }
}
