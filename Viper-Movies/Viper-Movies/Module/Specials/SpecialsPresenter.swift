//
//  SpecialsPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

protocol SpecialsPresenterProtocol: AnyObject {
    var fetchedMovies: [MovResult]? { get }
    func getOptions() -> ([SelectedType])
    func fetchInitialData(selectedType: String)
}

final class SpecialsPresenter {
    weak var view: SpecialsViewControllerProtocol?
    var interactor: SpecialsInteractorProtocol?
    var router: SpecialsRouterProtocol?
    
    var movies: [MovResult] = []
    
    init(view: SpecialsViewControllerProtocol, interactor: SpecialsInteractorProtocol, router: SpecialsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SpecialsPresenter: SpecialsInteractorOutputProtocol {
    func fetchSelectedTypeMoviesOutput(result: MoviesResult) {
        switch result {
        case .success(let movies):
            self.movies.append(contentsOf: movies.results ?? [])
            view?.reloadData()
        case .failure(let error):
            //TODO: alert
            print("***Specials datasını çekerken hata oluştu \(error)")
        }
    }
    
}

extension SpecialsPresenter: SpecialsPresenterProtocol {

    var fetchedMovies: [MovResult]? {
        get {
            return movies
        }
    }
    
    func fetchInitialData(selectedType: String) {
        guard let selectedEnumType = SelectedType(rawValue: selectedType) else {
            interactor?.fetchSelectedTypeMovies(selectedType: .nowPlaying, page: nil)
            return
        }
        interactor?.fetchSelectedTypeMovies(selectedType: selectedEnumType, page: nil)
    }
    
    func getOptions() -> ([SelectedType]) {
        return [.nowPlaying, .topRated, .upcoming]
    }
    
}
