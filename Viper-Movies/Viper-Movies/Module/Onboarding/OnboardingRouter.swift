//
//  onboardingRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation
import UIKit.UINavigationBar

protocol onboardingRouterProtocol: AnyObject {
    func navigate(_ route: onboardingRoutes)
}

enum onboardingRoutes {
    case mainScreen
    case tabBar
}

final class onboardingRouter {
    
    weak var viewController: OnboardingViewController?
    
    static func createModule() -> OnboardingViewController {
        let view = OnboardingViewController()
        let interactor = onboardingInteractor()
        let router = onboardingRouter()
        let presenter = onboardingPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
    
}

extension onboardingRouter: onboardingRouterProtocol {
    func navigate(_ route: onboardingRoutes) {
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
