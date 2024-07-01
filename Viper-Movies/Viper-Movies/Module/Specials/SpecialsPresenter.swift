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
    func fetchData(selectedType: String)
    func didSelect(movieId: Int)
    func loadMoreData(selectedType: String)
}

final class SpecialsPresenter {
    weak var view: SpecialsViewControllerProtocol?
    var interactor: SpecialsInteractorProtocol?
    var router: SpecialsRouterProtocol?
    
    var movies: [MovResult] = []
    var pageCount : Int?
    var currentPage = 1
    
    init(view: SpecialsViewControllerProtocol, interactor: SpecialsInteractorProtocol, router: SpecialsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SpecialsPresenter: SpecialsInteractorOutputProtocol {
    func fetchSelectedTypeMoviesOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let movies):
            //TODO: load more olduğunda removeall yapmadan tip değiştiğinde removeall yaparak ilerlemek gerek
            pageCount = movies.total_pages ?? 1
            self.movies.removeAll(keepingCapacity: false)
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
    
    func fetchData(selectedType: String) {
        guard let selectedEnumType = SelectedType(rawValue: selectedType) else {
            interactor?.fetchSelectedTypeMovies(selectedType: .popular, page: nil)
            return
        }
        view?.showLoadingView()
        interactor?.fetchSelectedTypeMovies(selectedType: selectedEnumType, page: nil)
    }
    
    func getOptions() -> ([SelectedType]) {
        return [.popular, .topRated, .upcoming]
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
    //TODO: tip değişimine göre currentpage vs. sıfırlanması gerekecek?
    func loadMoreData(selectedType: String) {
        guard let selectedEnumType = SelectedType(rawValue: selectedType),
              currentPage != pageCount ?? 1 else { return }
        currentPage += 1
        interactor?.fetchSelectedTypeMovies(selectedType: selectedEnumType , page: currentPage)
    }
    
}
