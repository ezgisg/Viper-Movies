//
//  DetailRouter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import Foundation

protocol DetailRouterProtocol: AnyObject {
    
}

final class DetailRouter {
    weak var viewController: DetailViewController?
    var presenter: DetailPresenterProtocol?

    
    static func createModule(movieId: Int) -> DetailViewController {
        let view = DetailViewController()
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router, movieId: movieId)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}

extension DetailRouter: DetailRouterProtocol {
    
}
