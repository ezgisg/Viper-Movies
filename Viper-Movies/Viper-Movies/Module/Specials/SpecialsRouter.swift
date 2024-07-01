//
//  SpecialsRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

protocol SpecialsRouterProtocol: AnyObject {
    
}

final class SpecialsRouter {
    weak var viewController: SpecialsViewController?
    var presenter: SpecialsPresenterProtocol?
    
    static func createModule() -> SpecialsViewController {
        let view =  SpecialsViewController()
        let interactor = SpecialsInteractor()
        let router =  SpecialsRouter()
        let presenter =  SpecialsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension SpecialsRouter: SpecialsRouterProtocol {
    
}
