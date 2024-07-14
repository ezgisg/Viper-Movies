//
//  SplashRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation
import UIKit.UINavigationBar

// MARK: - SplashRouterProtocol
protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

// MARK: - Enum
enum SplashRoutes {
    case onboarding
    case tabBar
}

// MARK: - SplashRouter
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

// MARK: - SplashRouterProtocol
extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .onboarding:
            let onboardingVC = OnboardingRouter.createModule()
            let navigationController = UINavigationController(rootViewController: onboardingVC)
            makeTransaction(with: navigationController, options: .transitionCrossDissolve)
        case .tabBar:
            let tabBarController = TabBarController()
            makeTransaction(with: tabBarController, options: .transitionFlipFromRight)
        }
    }
}

// MARK: - Helpers
private extension SplashRouter {
    final func makeTransaction(with viewController:  UIViewController?, options:  UIView.AnimationOptions) {
        guard let window = self.viewController?.view.window else { return }
        UIView.transition(with: window, duration: 1, options: options, animations: {
            window.rootViewController = viewController
        })
    }
}
