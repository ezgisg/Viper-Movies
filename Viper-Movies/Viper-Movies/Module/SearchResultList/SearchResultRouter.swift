//
//  SearchResultRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 4.07.2024.
//

import Foundation


protocol SearchResultRouterProtocol: AnyObject {
    func navigate(_ route: MainRoutes, movieId: Int)
}

final class SearchResultRouter {
    weak var viewController: SearchResultViewController?
    var presenter: SearchResultPresenterProtocol?
    
    static func createModule(query: String, movies: [MovResult], totalPage: Int) -> SearchResultViewController {
        let view = SearchResultViewController()
        let interactor = SearchResultInteractor()
        let router = SearchResultRouter()
        let presenter = SearchResultPresenter(view: view, interactor: interactor, router: router, query: query, movies: movies, totalPage: totalPage)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension SearchResultRouter: SearchResultRouterProtocol {
    func navigate(_ route: MainRoutes, movieId: Int) {
        switch route {
        case .detail:
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
}
