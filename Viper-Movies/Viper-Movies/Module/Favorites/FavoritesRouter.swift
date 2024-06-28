//
//  FavoritesRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import Foundation

protocol FavoritesRouterProtocol: AnyObject {
    func navigate(_ route: FavoritesRoutes, movieId: Int)
}

enum FavoritesRoutes {
    case detail
}


final class FavoritesRouter {
    weak var viewController: FavoritesViewController?
    var presenter: FavoritesPresenterProtocol?
    
    static func createModule() -> FavoritesViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()
        let presenter = FavoritesPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension FavoritesRouter: FavoritesRouterProtocol {
    func navigate(_ route: FavoritesRoutes, movieId: Int) {
        switch route {
        case .detail:
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
