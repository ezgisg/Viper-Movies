//
//  SearchResultInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import Foundation


protocol SearchResultInteractorProtocol: AnyObject {
    func searchWithQuery(query: String, year: String?, page: Int?)
}

protocol SearchResultInteractorOutputProtocol: AnyObject {
    func searchWithQueryOutput(result: MoviesResult)
}


final class SearchResultInteractor {
    var presenter: SearchResultPresenterProtocol?
    var output: SearchResultInteractorOutputProtocol?
    private var service = MoviesService()
}

extension SearchResultInteractor: SearchResultInteractorProtocol {
    func searchWithQuery(query: String, year: String?, page: Int?) {
        service.fetchQuerySearch(query: query, primary_release_year: year, page: page) { MoviesResult in
            self.output?.searchWithQueryOutput(result: MoviesResult)
        }
    }
    
}
