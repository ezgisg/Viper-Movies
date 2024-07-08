//
//  SearchPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 3.07.2024.
//

import Foundation

// MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol: AnyObject {
    func load()
}

// MARK: - SearchPresenter
final class SearchPresenter {
    weak var view: SearchCellProtocol?
    private var movie: MovResult
    
    init(view: SearchCellProtocol, movie: MovResult) {
        self.view = view
        self.movie = movie
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    func load() {
        view?.setName(name: movie.title ?? "")
        view?.setYear(year: movie.releaseDate?.formatDate(from: "yyyy-MM-dd", to: "dd/MM/yyyy") ?? "")
    }
}
