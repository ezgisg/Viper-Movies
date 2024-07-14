//
//  SearchResultInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import Foundation

// MARK: - SearchResultInteractorProtocol
protocol SearchResultInteractorProtocol: AnyObject {
    func searchWithQuery(query: String, year: String?, page: Int?)
}

// MARK: - SearchResultInteractorOutputProtocol
protocol SearchResultInteractorOutputProtocol: AnyObject {
    func searchWithQueryOutput(result: MoviesResult)
}

// MARK: - SearchResultInteractor
final class SearchResultInteractor {
    var presenter: SearchResultPresenterProtocol?
    var output: SearchResultInteractorOutputProtocol?
    
    private var service = MoviesService()
}

// MARK: - SearchResultInteractorProtocol
extension SearchResultInteractor: SearchResultInteractorProtocol {
    ///Fetching data from search service with query
    func searchWithQuery(query: String, year: String?, page: Int?) {
        service.fetchQuerySearch(query: query, primaryReleaseYear: year, page: page) { [weak self] moviesResult in
            guard let self else { return }
            output?.searchWithQueryOutput(result: moviesResult)
        }
    }
    
}
