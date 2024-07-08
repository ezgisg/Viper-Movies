//
//  SimilarMoviePresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 25.06.2024.
//

import Foundation

// MARK: - SimilarMoviePresenterProtocol
protocol SimilarMoviePresenterProtocol: AnyObject {
    func load()
}

// MARK: - SimilarMoviePresenter
final class SimilarMoviePresenter {
    let view: SimilarMovieCellProtocol?
    private var similarMovieResult: MovResult
    
    init(view: SimilarMovieCellProtocol?, similarMovieResult: MovResult) {
        self.view = view
        self.similarMovieResult = similarMovieResult
    }
}

// MARK: - SimilarMoviePresenterProtocol
extension SimilarMoviePresenter: SimilarMoviePresenterProtocol {
    func load() {
        view?.setNameTitle(title: similarMovieResult.title ?? "")
        guard let path = similarMovieResult.backdropPath else {
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(Constants.URLPaths.imageBase)\(path)"
        view?.setImage(imagePath: fullUrl)
    }
}
