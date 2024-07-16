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
        static let upcoming = L10n.upcomingMovies.localized()
        static let noResult = L10n.noResult.localized()
    }
    
    struct NoConnectionMessages {
        static let noConnectionTitle = L10n.noConnection.localized()
        static let noConnectionMessage = L10n.noConnectionMessage.localized()
    }
}


