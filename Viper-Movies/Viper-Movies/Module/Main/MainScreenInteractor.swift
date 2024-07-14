//
//  MainScreenInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

// MARK: - MainScreenInteractorProtocol
protocol MainScreenInteractorProtocol: AnyObject {
    func fetchNowPlayingMovies(page: Int?)
    func searchWithQuery(query: String, year: String?, page: Int?)
}

// MARK: - MainScreenInteractorOutputProtocol
protocol MainScreenInteractorOutputProtocol: AnyObject {
    func fetchNowPlayingMoviesOutput(result: MoviesResult)
    func searchWithQueryOutput(result: MoviesResult)
}

// MARK: - MainScreenInteractor
final class MainScreenInteractor {
    var presenter: MainScreenPresenterProtocol?
    var output: MainScreenInteractorOutputProtocol?
    private var service = MoviesService()
}

extension MainScreenInteractor: MainScreenInteractorProtocol {
    ///Fetching data from now playing service
    func fetchNowPlayingMovies(page: Int?) {
        service.fetchNowPlayingMovies(page: page) { [weak self] MoviesResult in
            guard let self else { return }
            output?.fetchNowPlayingMoviesOutput(result: MoviesResult)
        }
    }
    
    ///Fetching data from search service with query
    func searchWithQuery(query: String, year: String?, page: Int?) {
        service.fetchQuerySearch(query: query, primaryReleaseYear: year, page: page) { [weak self]  movieResult in
            guard let self else { return }
            output?.searchWithQueryOutput(result: movieResult)
        }
    }
    
}
