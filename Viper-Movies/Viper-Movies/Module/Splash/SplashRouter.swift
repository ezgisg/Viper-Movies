//
//  SplashRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation
import UIKit.UINavigationBar

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

enum SplashRoutes {
    case mainScreen
    case tabBar
}

final class SplashRouter {
    
    weak var viewController: SplashViewController?
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
    
}

extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .mainScreen:
            guard let window = viewController?.view.window else { return }
            let mainVC = MainScreenRouter.createModule()
            let navigationController = UINavigationController(rootViewController: mainVC )
            window.rootViewController = navigationController
        case .tabBar:
            break
        }
    }
    
}
