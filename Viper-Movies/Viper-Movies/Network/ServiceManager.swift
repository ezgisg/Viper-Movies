//
//  ServiceManager.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

protocol MoviesServiceProtocol {
    func fetchNowPlayingMovies(page: Int?, completion: @escaping (MoviesResult) -> ())
    func fetchPopularMovies(page: Int?, completion: @escaping (MoviesResult) -> ())
    func fetchTopRatedMovies(page: Int?, completion: @escaping (MoviesResult) -> ())
    func fetchUpcomingMovies(page: Int?, completion: @escaping (MoviesResult) -> ())
    func fetchMovieDetails(movieId: Int32, completion: @escaping (MovieDetailsResult) -> ())
}

class MoviesService: MoviesServiceProtocol {
    
    func fetchNowPlayingMovies(page: Int?, completion: @escaping (MoviesResult) -> ()) {
        NetworkManager.shared.request(Router.nowPlaying(page: page), decodeToType: MoviesResponse.self, completion: completion)
    }
    
    func fetchPopularMovies(page: Int?, completion: @escaping (MoviesResult) -> ()) {
        NetworkManager.shared.request(Router.popular(page: page), decodeToType: MoviesResponse.self, completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int?, completion: @escaping (MoviesResult) -> ()) {
        NetworkManager.shared.request(Router.topRated(page: page), decodeToType: MoviesResponse.self, completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int?, completion: @escaping (MoviesResult) -> ()) {
        NetworkManager.shared.request(Router.upcoming(page: page), decodeToType: MoviesResponse.self, completion: completion)
    }
    
    func fetchMovieDetails(movieId: Int32, completion: @escaping (MovieDetailsResult) -> ()) {
        NetworkManager.shared.request(Router.details(movieId: movieId), decodeToType: MovieDetailsResponse.self, completion: completion)
    }
    
}

typealias MoviesResult = Result<MoviesResponse, Error>
typealias MovieDetailsResult = Result<MovieDetailsResponse, Error>
