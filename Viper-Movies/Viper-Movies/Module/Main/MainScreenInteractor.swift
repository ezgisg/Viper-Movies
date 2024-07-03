//
//  MainScreenInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenInteractorProtocol: AnyObject {
    func fetchNowPlayingMovies(page: Int?)
    func searchWithQuery(query: String, year: String?, page: String?)
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    func fetchNowPlayingMoviesOutput(result: MoviesResult)
    func searchWithQueryOutput(result: MoviesResult)
}

final class MainScreenInteractor {
    var presenter: MainScreenPresenterProtocol?
    var output: MainScreenInteractorOutputProtocol?
    private var service = MoviesService()
}

extension MainScreenInteractor: MainScreenInteractorProtocol {
    func fetchNowPlayingMovies(page: Int?) {
        service.fetchNowPlayingMovies(page: page) { MoviesResult in
            self.output?.fetchNowPlayingMoviesOutput(result: MoviesResult)
        }
    }
    
    func searchWithQuery(query: String, year: String?, page: String?) {
        service.fetchQuerySearch(query: query, primary_release_year: year, page: page) { MoviesResult in
            self.output?.searchWithQueryOutput(result: MoviesResult)
        }
    }
    
}
