//
//  DetailRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

protocol DetailRouterProtocol: AnyObject {
    func navigate(_ route: DetailRoutes, movieId: Int)
}

enum DetailRoutes {
    case detail
}


final class DetailRouter {
    weak var viewController: DetailViewController?
    var presenter: DetailPresenterProtocol?

    
    static func createModule(movieId: Int) -> DetailViewController {
        let view = DetailViewController()
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router, movieId: movieId)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension DetailRouter: DetailRouterProtocol {
    func navigate(_ route: DetailRoutes, movieId: Int) {
        switch route {
        case .detail:
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
}
