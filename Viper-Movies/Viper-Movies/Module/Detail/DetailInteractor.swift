//
//  DetailInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

protocol DetailInteractorProtocol: AnyObject {
    func fetchSimilarMovies(page: Int?, movieId: Int32)
    func fetchMovieDetail(movieId: Int32)
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func fetchSimilarMoviesOutput(result: MoviesResult)
    func fetchMovieDetailOutput(result: MovieDetailsResult)
}

final class DetailInteractor {
    var presenter: DetailPresenterProtocol?
    var output: DetailInteractorOutputProtocol?
    private var service = MoviesService()
}

extension DetailInteractor: DetailInteractorProtocol {
    func fetchSimilarMovies(page: Int?, movieId: Int32) {
        service.fetchSimilarMovies(page: page, movieId: movieId) { MoviesResult in
            self.output?.fetchSimilarMoviesOutput(result: MoviesResult)
        }
    }

    func fetchMovieDetail(movieId: Int32) {
        service.fetchMovieDetails(movieId: movieId) { MovieDetailsResult in
            self.output?.fetchMovieDetailOutput(result: MovieDetailsResult)
        }
    }
}
