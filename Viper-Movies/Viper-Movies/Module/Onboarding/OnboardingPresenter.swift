//
//  onboardingPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

// MARK: - OnboardingPresenterProtocol
protocol OnboardingPresenterProtocol: AnyObject {
    func viewDidAppear()
    func goToTabBar()
}

// MARK: - OnboardingPresenter
final class OnboardingPresenter {
    // MARK: - Module Components
    weak var view: OnboardingViewControllerProtocol?
    var interactor: OnboardingInteractorProtocol?
    var router: OnboardingRouterProtocol?
    
    init(view: OnboardingViewControllerProtocol, interactor: OnboardingInteractorProtocol, router: OnboardingRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - OnboardingPresenterProtocol
extension OnboardingPresenter: OnboardingPresenterProtocol {
    func viewDidAppear() {
        isConnectedToInternet()
    }
    
    func goToTabBar() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.isFirstLaunch)
        router?.navigate(.tabBar)
    }
}

// MARK: - OnboardingInteractorOutputProtocol
extension OnboardingPresenter: onboardingInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            break
        case false:
            view?.makeAlert(title: Constants.NoConnectionMessages.noConnectionTitle, message: Constants.NoConnectionMessages.noConnectionMessage)
        }
    }
}

// MARK: - Helpers
private extension OnboardingPresenter {
    final func isConnectedToInternet() {
        interactor?.isConnected()
    }
}
