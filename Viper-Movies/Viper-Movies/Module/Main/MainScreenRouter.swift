//
//  MainScreenRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenRouterProtocol: AnyObject {

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

    
    
}
