//
//  SpecialsPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

// MARK: - SpecialsPresenterProtocol
protocol SpecialsPresenterProtocol: AnyObject {
    var fetchedMovies: [MovResult]? { get }
    var currentPage: Int { get set }
    
    func getOptions() -> [String]
    func fetchData(selectedType: String)
    func didSelect(movieId: Int)
    func loadMoreData(selectedType: String)
    func removeAllMovies()
}

// MARK: - SpecialsPresenter
final class SpecialsPresenter {
    // MARK: - Module Components
    weak var view: SpecialsViewControllerProtocol?
    var interactor: SpecialsInteractorProtocol?
    var router: SpecialsRouterProtocol?
    
    // MARK: - Private Variables
    private var movies: [MovResult] = []
    private var pageCount : Int?
    
    // MARK: - Global Variables
    var currentPage = 1
    
    init(view: SpecialsViewControllerProtocol, interactor: SpecialsInteractorProtocol, router: SpecialsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - SpecialsInteractorOutputProtocol
extension SpecialsPresenter: SpecialsInteractorOutputProtocol {
    func fetchSelectedTypeMoviesOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let fetchedMovies):
            pageCount = fetchedMovies.total_pages ?? 1
            movies.append(contentsOf: fetchedMovies.results ?? [])
            view?.reloadData()
        case .failure(let error):
            view?.showFailureAlert(error: error)
        }
    }
    
}

// MARK: - SpecialsPresenterProtocol
extension SpecialsPresenter: SpecialsPresenterProtocol {
    var fetchedMovies: [MovResult]? {
        return movies
    }
    
    func fetchData(selectedType: String) {
        guard let selectedEnumType = SelectedType(rawValue: selectedType) else {
            interactor?.fetchSelectedTypeMovies(selectedType: .popular, page: nil)
            return
        }
        view?.showLoadingView()
        interactor?.fetchSelectedTypeMovies(selectedType: selectedEnumType, page: nil)
    }
    
    ///To get types of data
    func getOptions() -> [String] {
        let options: [SelectedType] = [.topRated, .upcoming, .popular]
        return options.map { ($0.localized) }
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
    
    ///For loading data with pagination
    func loadMoreData(selectedType: String) {
        guard let selectedEnumType = SelectedType(rawValue: selectedType),
              currentPage != pageCount ?? 1 else { return }
        currentPage += 1
        view?.showLoadingView()
        interactor?.fetchSelectedTypeMovies(selectedType: selectedEnumType , page: currentPage)
    }
    
    ///To remove movies array when type is changed
    func removeAllMovies() {
        movies.removeAll(keepingCapacity: false)
        view?.reloadData()
    }
}
