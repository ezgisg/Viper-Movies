//
//  DetailPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var movieId: Int { get }
}

final class DetailPresenter {
    weak var view: DetailViewControllerProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var movieId: Int
    
    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol, movieId: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movieId = movieId
    }
    
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func fetchSimilarMoviesOutput(result: MoviesResult) {
        
    }
    
    func fetchMovieDetailOutput(result: MovieDetailsResult) {
        
    }
    
    
}

extension DetailPresenter: DetailPresenterProtocol {

}
