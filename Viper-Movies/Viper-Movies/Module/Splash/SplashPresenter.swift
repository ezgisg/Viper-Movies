//
//  SplashPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

// MARK: - SearchResultInteractorOutputProtocol
protocol SplashPresenterProtocol: AnyObject {
    func checkConnection()
}

// MARK: - SplashPresenter
final class SplashPresenter {
    // MARK: - Module Components
    weak var view: SplashViewControllerProtocol?
    var interactor: SplashInteractorProtocol?
    var router: SplashRouterProtocol?
    
    // MARK: - Private Variables
    private let isFirstLaunch = UserDefaults.standard.object(forKey: Constants.UserDefaults.isFirstLaunch)
    
    init(view: SplashViewControllerProtocol, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func isConnectedToInternet() {
        interactor?.isConnected()
    }
}

// MARK: - SplashPresenterProtocol
extension SplashPresenter: SplashPresenterProtocol {
    func checkConnection() {
        interactor?.isConnected()
    }
}

// MARK: - SplashInteractorOutputProtocol
extension SplashPresenter: SplashInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                ///To check whether the onboarding screen has been passed before
                guard let isFirstLaunch = UserDefaults.standard.object(forKey:  Constants.UserDefaults.isFirstLaunch) as? Bool,
                      isFirstLaunch == false else {
                self.router?.navigate(.onboarding)
                    return }
                self.router?.navigate(.tabBar)
            }
        case false:
            view?.makeAlert(title: Constants.NoConnectionMessages.noConnectionTitle, message: Constants.NoConnectionMessages.noConnectionMessage)
        }
    }
}


