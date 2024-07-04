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
    func searchLocal(text: String)
    func searchService(text: String)
    func loadMoreData()
    func getDates() -> (String?, String?)
    func didSelect(movieId: Int)
    var searchResult: [MovResult] { get set }
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
    var searchResult: [MovResult] = []
    
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
    
    func searchLocal(text: String) {
        guard text.count != 0 else {
            view?.movieListHeaderTitle = "Upcoming Movies"
            filteredMovies = movies
            view?.reloadCollectionViewData()
            return
        }
        
        let modifiedText = text.replacingOccurrences(of: "İ", with: "I").uppercased()
        filteredMovies = movies.filter {
            let modifiedTitle = $0.title?.replacingOccurrences(of: "i", with: "I").uppercased()
            return modifiedTitle?.contains(modifiedText) ?? false
        }
        if filteredMovies.count == 0 {
            view?.movieListHeaderTitle = "No result"
        } else {
            view?.movieListHeaderTitle = "Upcoming Movies"
        }
        view?.reloadCollectionViewData()
    }
    
    func searchService(text: String) {
        interactor?.searchWithQuery(query: text, year: nil, page: nil)
    }
    
    func loadMoreData() {
        guard currentPage != pageCount ?? 1 else { return }
        currentPage += 1
        interactor?.fetchNowPlayingMovies(page: currentPage)
    }
    
    func didSelect(movieId: Int) {
        router?.navigate(.detail, movieId: movieId)
    }
}


//MARK: MainScreenInteractorOutputProtocol
extension MainScreenPresenter: MainScreenInteractorOutputProtocol {
    func searchWithQueryOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let movies):
            self.searchResult = movies.results ?? []
            view?.reloadTableViewData(data: movies.results ?? [])
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
    
    func fetchNowPlayingMoviesOutput(result: MoviesResult) {
        view?.hideLoadingView()
        switch result {
        case .success(let movies):
            self.movies.append(contentsOf: movies.results ?? [])
            pageCount = movies.total_pages ?? 1
            minDate = movies.dates?.minimum?.formatDate(from: "yyyy-MM-dd", to: "dd.MM.yyyy") ?? ""
            maxDate =       movies.dates?.maximum?.formatDate(from: "yyyy-MM-dd", to: "dd.MM.yyyy") ?? ""
            filteredMovies = self.movies
            view?.reloadCollectionViewData()
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
}
