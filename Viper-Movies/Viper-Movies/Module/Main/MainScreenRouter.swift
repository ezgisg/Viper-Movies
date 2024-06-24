//
//  MainScreenRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation
import UIKit.UINavigationBar

protocol MainScreenRouterProtocol: AnyObject {
    func navigate(_ route: MainRoutes, movieId: Int)
}

enum MainRoutes {
    case detail
}


final class MainScreenRouter {
    weak var viewController: MainScreenViewController?
    var presenter: MainScreenPresenterProtocol?
    
    static func createModule() -> MainScreenViewController {
        let view = MainScreenViewController()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension MainScreenRouter: MainScreenRouterProtocol {
    func navigate(_ route: MainRoutes, movieId: Int) {
        switch route {
        case .detail:
            
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
