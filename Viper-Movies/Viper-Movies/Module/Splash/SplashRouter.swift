//
//  SplashRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation
import UIKit.UINavigationBar

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

enum SplashRoutes {
    case onboarding
    case tabBar
}

final class SplashRouter {
    var presenter: SplashPresenterProtocol?
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
        case .onboarding:
            guard let window = viewController?.view.window else { return }
            let onboardingVC = onboardingRouter.createModule()
            let navigationController = UINavigationController(rootViewController: onboardingVC )
            UIView.transition(with: window, duration: 1, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            })
        case .tabBar:
            guard let window = viewController?.view.window else { return }
            let tabBarController = TabBarController()
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                window.rootViewController = tabBarController
            })
        }
    }

}
