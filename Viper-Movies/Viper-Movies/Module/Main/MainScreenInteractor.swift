//
//  MainScreenInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenInteractorProtocol: AnyObject {
    func fetchNowPlayingMovies(page: Int?)
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    func fetchNowPlayingMoviesOutput(result: MoviesResult)
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
}
