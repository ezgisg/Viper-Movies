//
//  DetailPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var movieId: Int { get set }
    func getSimilars() -> [MovResult]
    func getDetails() -> MovieDetailsResponse?
    func loadDatas()
    func didSelect(movieId: Int)
 
}

protocol DetailPresenterDelegate: AnyObject {
    func fetchedSimilars()
    func fetchedDetails()
}

final class DetailPresenter {
    weak var view: DetailViewControllerProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var movieId: Int
    var delegate: DetailPresenterDelegate?
    
    var similarMovies: [MovResult] = []
    var movieDetail: MovieDetailsResponse? = nil
    
    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol, movieId: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movieId = movieId
    }
    
    private func loadImage() {
        let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
        guard let path = movieDetail?.backdrop_path else {
            view?.setImage(imageUrlString: "")
            return }
        let fullUrl = "\(imageBaseUrl)\(path)"
        view?.setImage(imageUrlString: fullUrl)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func fetchSimilarMoviesOutput(result: MoviesResult) {
        similarMovies.removeAll(keepingCapacity: true)
        switch result {
        case .success(let movies):
            self.similarMovies.append(contentsOf: movies.results ?? [])
            //TODO: reload data . for now just print
            self.delegate?.fetchedSimilars()
        case .failure(let error):
            //TODO: alert
            print("***Benzer filmler datasını çekerken hata oluştu \(error)")
      
        }
    }
    
    func fetchMovieDetailOutput(result: MovieDetailsResult) {
        switch result {
        case .success(let detail):
            self.movieDetail = detail
            self.loadImage()
            self.delegate?.fetchedDetails()
            //TODO: reload data
        case .failure(let error):
            print("***Detay datasını çekerken hata oluştu \(error)")
        }
    }
    
    
}

extension DetailPresenter: DetailPresenterProtocol {
  

    func getSimilars() -> [MovResult] {
        return similarMovies
    }
    
    func getDetails() -> MovieDetailsResponse? {
        return movieDetail
    }
    
    func loadDatas() {
        interactor?.fetchMovieDetail(movieId: Int32(self.movieId))
        interactor?.fetchSimilarMovies(page: nil, movieId: Int32(self.movieId))
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
}
