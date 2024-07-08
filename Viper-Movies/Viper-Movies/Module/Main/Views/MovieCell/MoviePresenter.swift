//
//  MoviePresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import Foundation

// MARK: - MoviePresenterProtocol
protocol MoviePresenterProtocol: AnyObject {
    func load()
}

// MARK: - MoviePresenter
final class MoviePresenter {
    let view: MovieCellProtocol?
    private var movieResult: MovResult
    
    init(view: MovieCellProtocol?, movieResult: MovResult) {
        self.view = view
        self.movieResult = movieResult
    }
}

// MARK: - MoviePresenterProtocol
extension MoviePresenter: MoviePresenterProtocol {
    func load() {
        view?.setTitle(title: movieResult.title ?? "")
        view?.setDescription(description: movieResult.overview ?? "")
        view?.setDetail(detail: movieResult.releaseDate ?? "")
        guard let path = movieResult.backdropPath else { 
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(Constants.URLPaths.imageBase)\(path)"
        view?.setImage(imagePath: fullUrl)

    }

}
