//
//  SearchResultPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import Foundation

// MARK: - SearchResultPresenterProtocol
protocol SearchResultPresenterProtocol: AnyObject {
    func getMovies() -> [MovResult]
    func didSelect(movieId: Int)
    func loadMore()
}

// MARK: - SearchResultPresenter
final class SearchResultPresenter {
    // MARK: - Module Components
    weak var view: SearchResultViewControllerProtocol?
    var interactor: SearchResultInteractorProtocol?
    var router: SearchResultRouterProtocol?
    
    // MARK: - Private Variables
    private var query: String
    private var movies: [MovResult]
    private var page: Int = 1
    private var totalPage: Int
    
    // MARK: - Init
    init(view: SearchResultViewControllerProtocol, interactor: SearchResultInteractorProtocol, router: SearchResultRouterProtocol, query: String, movies: [MovResult], totalPage: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.query = query
        self.movies = movies
        self.totalPage = totalPage
    }
}

// MARK: - SearchResultPresenterProtocol
extension SearchResultPresenter: SearchResultPresenterProtocol {
    func getMovies() -> [MovResult] {
        return movies
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
    /// To load more when scroll to bottom - pagination
    func loadMore() {
        guard totalPage > page else { return }
        view?.showLoadingView()
        page += 1
        interactor?.searchWithQuery(query: query, year: nil, page: page)
    }
}

// MARK: - SearchResultInteractorOutputProtocol
extension SearchResultPresenter: SearchResultInteractorOutputProtocol {
    ///Fetching data from search service with query
    func searchWithQueryOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let fetchedMovies):
            movies.append(contentsOf: fetchedMovies.results ?? [])
            view?.reloadData()
        case .failure(let error):
            view?.showFailureAlert(error: error)
        }
    }
}
