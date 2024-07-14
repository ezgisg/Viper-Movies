//
//  Constants.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 5.07.2024.
//

import Foundation

// MARK: - Constants
struct Constants {
    struct UserDefaults {
         static let favorites = "favorites"
         static let isFirstLaunch = "isFirstLaunch?"
    }
    
    struct URLPaths {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let imbdBaseURL = "https://www.imdb.com/title"
        static let imageBase = "https://image.tmdb.org/t/p/w500/"
    }
    
    struct Titles {
        static let upcoming = "Upcoming Movies"
        static let noResult = "No Result"
    }
    
    struct NoConnectionMessages {
        static let noConnectionTitle = "No Connection"
        static let noConnectionMessage = "Please check your internet connection"
    }
}


