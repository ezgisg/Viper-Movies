//
//  SpecialsRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

// MARK: - SpecialsRouterProtocol
protocol SpecialsRouterProtocol: AnyObject {
    func navigate(_ route: SpecialsRoutes, movieId: Int)
}

// MARK: - Enum
enum SpecialsRoutes {
    case detail
}

// MARK: - SpecialsRouter
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

// MARK: - SpecialsRouterProtocol
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
