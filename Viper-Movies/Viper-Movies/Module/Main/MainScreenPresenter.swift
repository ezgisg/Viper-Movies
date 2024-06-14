//
//  MainScreenPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func getMovies() -> [MovResult]
    func getBanners() -> [MovResult]
    func fetchInitialData()
    func search(text: String)
    func loadMoreData()
    func getDates() -> (String?, String?)
}

protocol MainScreenPresenterDelegate: AnyObject {
    func sendMovies() -> [MovResult]
}

final class MainScreenPresenter {
    weak var view: MainScreenViewControllerProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    
    var movies: [MovResult] = []
    var filteredMovies: [MovResult] = []
    var banners: [MovResult] = []
    var pageCount : Int?
    var currentPage = 1
    var minDate: String?
    var maxDate: String?
    
    init(view: MainScreenViewControllerProtocol, interactor: MainScreenInteractorProtocol, router: MainScreenRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

//MARK: MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
    func getDates() -> (String?, String?) {
        return (minDate, maxDate)
    }
    
    func getMovies() -> [MovResult] {
        return filteredMovies
    }
    
    /// adding new identifier for diffable datasource unique data needs
    /// - Returns: [MovResult]
    func getBanners() -> [MovResult] {
        ///banners.count control added because when the collection view is reloaded, this function runs again and give them new identifer and causes vibration
        guard banners.count != movies.count || banners.count == 0 else { return banners }
        banners = movies
        movies.enumerated().forEach { index, _ in
            banners[index].identifier = UUID()
        }
        return banners
    }
    
    func fetchInitialData() {
        interactor?.fetchNowPlayingMovies(page: nil)
    }
    
    func search(text: String) {
        guard text.count != 0 else {
            filteredMovies = movies
            view?.reloadData()
            return }
        filteredMovies = movies.filter {
            $0.title?.lowercased().contains(text.lowercased()) ?? false }
        view?.reloadData()
    }

    func loadMoreData() {
        guard currentPage != pageCount ?? 1 else { return }
        currentPage += 1
        interactor?.fetchNowPlayingMovies(page: currentPage)
    }
}

//TODO: date type which is used for bottom of cell will change
//MARK: MainScreenInteractorOutputProtocol
extension MainScreenPresenter: MainScreenInteractorOutputProtocol {
    //TODO: fetch other pages with scrool
    func fetchNowPlayingMoviesOutput(result: MoviesResult) {
        switch result {
        case .success(let movies):
            self.movies.append(contentsOf: movies.results ?? [])
            pageCount = movies.total_pages ?? 1
            minDate = movies.dates?.minimum ?? ""
            maxDate = movies.dates?.maximum ?? ""
            filteredMovies = self.movies
            view?.reloadData()
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
}
