//
//  DetailInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

// MARK: - DetailInteractorProtocol
protocol DetailInteractorProtocol: AnyObject {
    func fetchSimilarMovies(page: Int?, movieId: Int32)
    func fetchMovieDetail(movieId: Int32)
}

// MARK: - DetailInteractorOutputProtocol
protocol DetailInteractorOutputProtocol: AnyObject {
    func fetchSimilarMoviesOutput(result: MoviesResult)
    func fetchMovieDetailOutput(result: MovieDetailsResult)
}

// MARK: - DetailInteractor
final class DetailInteractor {
    var presenter: DetailPresenterProtocol?
    var output: DetailInteractorOutputProtocol?
    private var service = MoviesService()
}

// MARK: - DetailInteractorProtocol
extension DetailInteractor: DetailInteractorProtocol {
    func fetchSimilarMovies(page: Int?, movieId: Int32) {
        service.fetchSimilarMovies(page: page, movieId: movieId) { [weak self] moviesResult in
            guard let self else { return }
            output?.fetchSimilarMoviesOutput(result: moviesResult)
        }
    }

    func fetchMovieDetail(movieId: Int32) {
        service.fetchMovieDetails(movieId: movieId) { [weak self] movieDetailsResult in
            guard let self else { return }
            output?.fetchMovieDetailOutput(result: movieDetailsResult)
        }
    }
}
