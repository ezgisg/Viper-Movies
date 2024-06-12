//
//  MainScreenPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    
}

final class MainScreenPresenter {
    weak var view: MainScreenViewControllerProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    
    init(view: MainScreenViewControllerProtocol, interactor: MainScreenInteractorProtocol, router: MainScreenRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenPresenterProtocol {
    
}


extension MainScreenPresenter: MainScreenInteractorOutputProtocol {
    
}
