//
//  SpecialsInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import Foundation

// MARK: - Enum
enum SelectedType: String {
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
}

// MARK: - SpecialsInteractorProtocol
protocol SpecialsInteractorProtocol: AnyObject {
    func fetchSelectedTypeMovies(selectedType: SelectedType, page:Int?)
}

// MARK: - SpecialsInteractorOutputProtocol
protocol SpecialsInteractorOutputProtocol: AnyObject {
    func fetchSelectedTypeMoviesOutput(result: MoviesResult)
}

// MARK: - SpecialsInteractor
final class SpecialsInteractor {
    var output: SpecialsInteractorOutputProtocol?
    var presenter: SpecialsPresenterProtocol?
    private var service = MoviesService()
}

// MARK: - SpecialsInteractorProtocol
extension SpecialsInteractor: SpecialsInteractorProtocol {
    func fetchSelectedTypeMovies(selectedType: SelectedType, page: Int?) {
        switch selectedType {
        case .popular:
            service.fetchPopularMovies(page: page) { MoviesResult in
                self.output?.fetchSelectedTypeMoviesOutput(result: MoviesResult)
            }
        case .topRated:
            service.fetchTopRatedMovies(page: page) { MoviesResult in
                self.output?.fetchSelectedTypeMoviesOutput(result: MoviesResult)
            }
        case .upcoming:
            service.fetchUpcomingMovies(page: page) { MoviesResult in
                self.output?.fetchSelectedTypeMoviesOutput(result: MoviesResult)
            }
        }
    }
}
