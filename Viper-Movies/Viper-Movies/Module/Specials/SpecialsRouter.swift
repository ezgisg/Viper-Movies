//
//  SpecialsRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

protocol SpecialsRouterProtocol: AnyObject {
    func navigate(_ route: SpecialsRoutes, movieId: Int)
}

enum SpecialsRoutes {
    case detail
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
    func navigate(_ route: SpecialsRoutes, movieId: Int) {
        switch route {
        case .detail:
            
            guard let navigationController = viewController?.navigationController else { return }
            let detailVC = DetailRouter.createModule(movieId: movieId)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
