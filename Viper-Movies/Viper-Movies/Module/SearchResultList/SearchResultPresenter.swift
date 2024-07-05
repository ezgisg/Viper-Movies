//
//  SearchResultPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import Foundation

protocol SearchResultPresenterProtocol: AnyObject {
    func getMovies() -> [MovResult]
    func didSelect(movieId: Int)
    func loadMore()
 
}

final class SearchResultPresenter {
    weak var view: SearchResultViewControllerProtocol?
    var interactor: SearchResultInteractorProtocol?
    var router: SearchResultRouterProtocol?
    var query: String
    var movies: [MovResult]
    var page: Int = 1
    var totalPage: Int
    
    init(view: SearchResultViewControllerProtocol, interactor: SearchResultInteractorProtocol, router: SearchResultRouterProtocol, query: String, movies: [MovResult], totalPage: Int) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.query = query
        self.movies = movies
        self.totalPage = totalPage
    }
}

extension SearchResultPresenter: SearchResultPresenterProtocol {

    func getMovies() -> [MovResult] {
        return movies
    }
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
    func loadMore() {
        if totalPage > page {
            view?.showLoadingView()
            page += 1
            interactor?.searchWithQuery(query: self.query, year: nil, page: page)
        }
    }
    
}


extension SearchResultPresenter: SearchResultInteractorOutputProtocol {
    func searchWithQueryOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let movies):
            self.movies.append(contentsOf: movies.results ?? [])
            view?.reloadData()
        case .failure(let error):
            view?.showFailureAlert(error: error)
        }
    }
}
