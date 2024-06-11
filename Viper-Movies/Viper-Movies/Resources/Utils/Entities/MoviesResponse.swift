//
//  MoviesResponse.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation


// MARK: - MoviesResponse
struct MoviesResponse: Decodable {
    let dates: Dates?
    let page: Int?
    let results: [MovResult]?
    let totalPages, totalResults: Int?
}

// MARK: - Dates
struct Dates: Decodable {
    let maximum, minimum: String?
}

// MARK: - MovResult
struct MovResult: Decodable  {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

enum OriginalLanguage: String, Decodable {
    case en
    case es
    case fi
}
