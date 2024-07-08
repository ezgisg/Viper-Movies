//
//  MainScreenRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation
import UIKit.UINavigationBar

// MARK: - MainScreenRouterProtocol
protocol MainScreenRouterProtocol: AnyObject {
    func navigate(_ route: MainRoutes, movieId: Int)
    func navigateToList(query: String , movies: [MovResult], totalPage: Int)
}

// MARK: - Enum
enum MainRoutes {
    case detail
}

// MARK: - MainScreenRouter
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

// MARK: - MainScreenRouter
extension MainScreenRouter: MainScreenRouterProtocol {
    ///To go to detail page
    func navigate(_ route: MainRoutes, movieId: Int) {
        switch route {
        case .detail:
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    ///To go to service "search result" list page
    func navigateToList(query: String, movies: [MovResult], totalPage: Int) {
        guard let navigationController = viewController?.navigationController else { return }
        let searchResultListVC = SearchResultRouter.createModule(query: query, movies: movies, totalPage: totalPage)
        navigationController.pushViewController(searchResultListVC, animated: true)
    }
}
