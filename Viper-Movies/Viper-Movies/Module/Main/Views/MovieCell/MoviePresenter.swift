//
//  MoviePresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import Foundation

protocol MoviePresenterProtocol: AnyObject {
    func load()
}

final class MoviePresenter {
    let view: MovieCellProtocol?
    private var movieResult: MovResult
    
    init(view: MovieCellProtocol?, movieResult: MovResult) {
        self.view = view
        self.movieResult = movieResult
    }
}

extension MoviePresenter: MoviePresenterProtocol {
    func load() {
        let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
        view?.setTitle(title: movieResult.title ?? "")
        view?.setDescription(description: movieResult.overview ?? "")
        view?.setDetail(detail: movieResult.releaseDate ?? "")
        guard let path = movieResult.backdropPath else { 
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(imageBaseUrl)\(path)"
        view?.setImage(imagePath: fullUrl)

    }

}
