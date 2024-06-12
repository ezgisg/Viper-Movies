//
//  onboardingPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

protocol onboardingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func goToTabBar()
}

extension onboardingPresenter {
    fileprivate enum Constans {
        static let noConnectionTitle = "No Connection"
        static let noConnectionMessage = "Please check your internet connection"
    }
}

final class onboardingPresenter {
    weak var view: OnboardingViewControllerProtocol?
    var interactor: onboardingInteractorProtocol?
    var router: onboardingRouterProtocol?
    
    init(view: OnboardingViewControllerProtocol, interactor: onboardingInteractorProtocol, router: onboardingRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

//MARK: onboardingPresenterProtocol
extension onboardingPresenter: onboardingPresenterProtocol {


    func viewDidLoad() {

    }
    
    func viewDidAppear() {
        isConnectedToInternet()
    }
    
    func goToTabBar() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch?")
        router?.navigate(.tabBar)
    }
    
    
    private func isConnectedToInternet() {
        interactor?.isConnected()
    }
    
    
    
}

//MARK: onboardingInteractorOutputProtocol
extension onboardingPresenter: onboardingInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            break
        case false:
            view?.makeAlert(title: Constans.noConnectionTitle, message: Constans.noConnectionMessage)
        }
    }
}
