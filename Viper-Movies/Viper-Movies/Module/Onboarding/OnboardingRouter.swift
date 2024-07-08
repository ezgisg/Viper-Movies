//
//  onboardingRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation
import UIKit.UINavigationBar

// MARK: - OnboardingRouterProtocol
protocol OnboardingRouterProtocol: AnyObject {
    func navigate(_ route: OnboardingRoutes)
}

// MARK: - OnboardingRouterProtocol
enum OnboardingRoutes {
    case tabBar
}

// MARK: - OnboardingRouter
final class OnboardingRouter {
    weak var viewController: OnboardingViewController?
    
    static func createModule() -> OnboardingViewController {
        let view = OnboardingViewController()
        let interactor = onboardingInteractor()
        let router = OnboardingRouter()
        let presenter = onboardingPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

// MARK: - OnboardingRouterProtocol
extension OnboardingRouter: OnboardingRouterProtocol {
    func navigate(_ route: OnboardingRoutes) {
        switch route {
        case .tabBar:
            guard let window = viewController?.view.window else { return }
            let tabBarController = TabBarController()
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                window.rootViewController = tabBarController
            })
        }
    }
    
}
