//
//  DetailPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

// MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol: AnyObject {
    var movieId: Int { get set }
    var delegate: DetailPresenterDelegate? { get set }
    func getSimilars() -> [MovResult]
    func getDetails() -> MovieDetailsResponse?
    func loadDatas()
    func didSelect(movieId: Int)
    func saveToUserDefaults()
    func getFromUserDefaults() -> [MovieFavoriteDetails]
}

// MARK: - DetailPresenterDelegate
protocol DetailPresenterDelegate: AnyObject {
    func fetchedDetails()
}

// MARK: - DetailPresenter
final class DetailPresenter {
    // MARK: - Module Components
    weak var view: DetailViewControllerProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    
    // MARK: - Global Variables
    var movieId: Int
    var similarMovies: [MovResult] = []
    var delegate: DetailPresenterDelegate?

    // MARK: - Private Variables
    private var movieDetail: MovieDetailsResponse? = nil
    
    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol, movieId: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movieId = movieId
    }
    
}

// MARK: - DetailInteractorOutputProtocol
extension DetailPresenter: DetailInteractorOutputProtocol {
    func fetchSimilarMoviesOutput(result: MoviesResult) {
        similarMovies.removeAll(keepingCapacity: true)
        view?.hideLoadingView()
        switch result {
        case .success(let movies):
            similarMovies.append(contentsOf: movies.results ?? [])
            view?.reloadData()
        case .failure(let error):
            view?.showFailureAlert(error: error)
        }
    }
    
    func fetchMovieDetailOutput(result: MovieDetailsResult) {
        switch result {
        case .success(let detail):
            movieDetail = detail
            loadImage()
            delegate?.fetchedDetails()
        case .failure(let error):
            view?.showFailureAlert(error: error)
        }
    }
}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {
    ///To save or remove from userdefaults "favorites"
    func saveToUserDefaults() {
        guard let favorite = movieDetail?.favorite else { return }
        var favorites = getFromUserDefaults()
        if let index = favorites.firstIndex(where: { $0.id == favorite.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(favorite)
        }
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.favorites)
        }
    }
    
    ///To get data from userdefaults "favorites"
    func getFromUserDefaults() -> [MovieFavoriteDetails] {
        guard let favorites = UserDefaults.standard.object(forKey: Constants.UserDefaults.favorites) as? Data,
              let decoded = try? JSONDecoder().decode([MovieFavoriteDetails].self, from: favorites) else { return [] }
        return decoded
    }
    
    func getSimilars() -> [MovResult] {
        return similarMovies
    }
    
    func getDetails() -> MovieDetailsResponse? {
        return movieDetail
    }

    func loadDatas() {
        interactor?.fetchMovieDetail(movieId: Int32(movieId))
        interactor?.fetchSimilarMovies(page: nil, movieId: Int32(movieId))
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
}

// MARK: - Helpers
extension DetailPresenter {
    private func loadImage() {
        guard let path = movieDetail?.backdrop_path else {
            view?.setImage(imagePath: "")
            return
        }
        view?.setImage(imagePath: path)
    }
}
