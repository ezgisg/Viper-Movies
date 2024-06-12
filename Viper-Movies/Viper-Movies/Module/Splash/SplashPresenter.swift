//
//  SplashPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func goToMainScreen()
}

extension SplashPresenter {
    fileprivate enum Constans {
        static let noConnectionTitle = "No Connection"
        static let noConnectionMessage = "Please check your internet connection"
    }
}

final class SplashPresenter {
    weak var view: SplashViewControllerProtocol?
    var interactor: SplashInteractorProtocol?
    var router: SplashRouterProtocol?
    
    init(view: SplashViewControllerProtocol, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

//MARK: SplashPresenterProtocol
extension SplashPresenter: SplashPresenterProtocol {


    func viewDidLoad() {

    }
    
    func viewDidAppear() {
        isConnectedToInternet()
    }
    
    func goToMainScreen() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch?")
        router?.navigate(.mainScreen)
    }
    
    
    private func isConnectedToInternet() {
        interactor?.isConnected()
    }
    
    
    
}

//MARK: SplashInteractorOutputProtocol
extension SplashPresenter: SplashInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            break
        case false:
            view?.makeAlert(title: Constans.noConnectionTitle, message: Constans.noConnectionMessage)
        }
    }
}
