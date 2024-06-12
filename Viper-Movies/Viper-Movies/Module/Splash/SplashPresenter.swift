//
//  SplashPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidLoad()
    func checkConnection()
}

extension SplashPresenter {
    fileprivate enum Constans {
        static let noConnectionTitle = "No Connection"
        static let noConnectionMessage = "Please check your internet connection"
    }
}

final class SplashPresenter {
    let isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch?")
    weak var view: SplashViewControllerProtocol?
    var interactor: SplashInteractorProtocol?
    var router: SplashRouterProtocol?
    
    init(view: SplashViewControllerProtocol, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func isConnectedToInternet() {
        interactor?.isConnected()
    }
    
    
}

extension SplashPresenter: SplashPresenterProtocol {
    func checkConnection() {
        interactor?.isConnected()
    }
    
    func viewDidLoad() {
      
    }
    
    
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self else { return }
                guard let isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch?") as? Bool,
                      isFirstLaunch == false else {
                self.router?.navigate(.onboarding)
                    return }
                self.router?.navigate(.mainScreen)
            }
        case false:
            view?.makeAlert(title: Constans.noConnectionTitle, message: Constans.noConnectionMessage)
        }
    }
}


