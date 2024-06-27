//
//  MovieDetailsResponse.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

// MARK: - MovieDetailsResponse
struct MovieDetailsResponse: Decodable {
    let adult: Bool?
    let backdrop_path: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdb_id, original_language, original_title, overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [ProductionCompany]?
    let production_countries: [ProductionCountry]?
    let release_date: String?
    let revenue, runtime: Int?
    let spoken_languages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    let favorite: MovieFavoriteDetails?
    
    init(adult: Bool?, backdrop_path: String?, budget: Int?, genres: [Genre]?, homepage: String?, id: Int?, imdb_id: String?, original_language: String?, original_title: String?, overview: String?, popularity: Double?, poster_path: String?, production_companies: [ProductionCompany]?, production_countries: [ProductionCountry]?, release_date: String?, revenue: Int?, runtime: Int?, spoken_languages: [SpokenLanguage]?, status: String?, tagline: String?, title: String?, video: Bool?, vote_average: Double?, vote_count: Int?, favorite: MovieFavoriteDetails?) {
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdb_id = imdb_id
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.production_companies = production_companies
        self.production_countries = production_countries
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
        self.spoken_languages = spoken_languages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
        self.favorite = favorite
    }
    
    enum CodingKeys: CodingKey {
        case adult
        case backdrop_path
        case budget
        case genres
        case homepage
        case id
        case imdb_id
        case original_language
        case original_title
        case overview
        case popularity
        case poster_path
        case production_companies
        case production_countries
        case release_date
        case revenue
        case runtime
        case spoken_languages
        case status
        case tagline
        case title
        case video
        case vote_average
        case vote_count
        case favorites
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdrop_path)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.imdb_id = try container.decodeIfPresent(String.self, forKey: .imdb_id)
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language)
        self.original_title = try container.decodeIfPresent(String.self, forKey: .original_title)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path)
        self.production_companies = try container.decodeIfPresent([ProductionCompany].self, forKey: .production_companies)
        self.production_countries = try container.decodeIfPresent([ProductionCountry].self, forKey: .production_countries)
        self.release_date = try container.decodeIfPresent(String.self, forKey: .release_date)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.spoken_languages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spoken_languages)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.vote_average = try container.decodeIfPresent(Double.self, forKey: .vote_average)
        self.vote_count = try container.decodeIfPresent(Int.self, forKey: .vote_count)
        self.favorite = MovieFavoriteDetails(backdrop_path: backdrop_path, id: id, title: title)
    }
}

// MARK: - Genre
struct Genre: Decodable  {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Decodable  {
    let id: Int?
    let logo_path: String?
    let name, origin_country: String?
}

// MARK: - ProductionCountry
struct ProductionCountry: Decodable  {
    let iso_3166_1, name: String?
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Decodable  {
    let english_name, iso_639_1, name: String?
}

struct MovieFavoriteDetails: Codable {
    let backdrop_path: String?
    let id: Int?
    let title: String?
    
    init(backdrop_path: String?, id: Int?, title: String?) {
        self.backdrop_path = backdrop_path
        self.id = id
        self.title = title
    }
}
