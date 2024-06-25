//
//  SimilarMoviePresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 25.06.2024.
//

import Foundation

protocol SimilarMoviePresenterProtocol: AnyObject {
    func load()
}

final class SimilarMoviePresenter {
    let view: SimilarMovieCellProtocol?
    private var similarMovieResult: MovResult
    
    init(view: SimilarMovieCellProtocol?, similarMovieResult: MovResult) {
        self.view = view
        self.similarMovieResult = similarMovieResult
    }
}

extension SimilarMoviePresenter: SimilarMoviePresenterProtocol {
    func load() {
        let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
        view?.setNameTitle(title: similarMovieResult.title ?? "")
        guard let path = similarMovieResult.backdropPath else {
            view?.setImage(imageUrlString: "")
            return }
        let fullUrl = "\(imageBaseUrl)\(path)"
        view?.setImage(imageUrlString: fullUrl)
    }
    
}
