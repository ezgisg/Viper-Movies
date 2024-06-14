//
//  MainScreenPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func getMovies() -> [MovResult]
    func getBanners() -> [MovResult]
    func viewDidLoad()
}

protocol MainScreenPresenterDelegate: AnyObject {
    func sendMovies() -> [MovResult]
}

final class MainScreenPresenter {
    weak var view: MainScreenViewControllerProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    var movies: [MovResult] = []
    
    init(view: MainScreenViewControllerProtocol, interactor: MainScreenInteractorProtocol, router: MainScreenRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenPresenterProtocol {
    func viewDidLoad() {
        interactor?.fetchNowPlayingMovies(page: nil)
    }
    
    func getMovies() -> [MovResult] {
        return movies
    }
    
    func getBanners() -> [MovResult] {
        var banners = movies
        movies.enumerated().forEach { index, _ in
            banners[index].identifier = UUID()
        }
        return banners
    }
    
}


extension MainScreenPresenter: MainScreenInteractorOutputProtocol {
    func fetchNowPlayingMoviesOutput(result: MoviesResult) {
        switch result {
        case .success(let movies):
            self.movies = movies.results ?? []
            view?.reloadData()
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
}
