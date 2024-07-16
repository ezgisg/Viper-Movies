//
//  LocalizableKeys.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 16.07.2024.
//

import Foundation


typealias L10n = LocalizableKey

// MARK: - LocalizableKey

public enum LocalizableKey: String, LocalizableProtocol {
    
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    case onboardingFirstMessage
    case onboardingSecondMessage
    case start
    case next
    case skip
    case posters
    case upcomingMovies
    case noConnection
    case noConnectionMessage
    case noResult
    case inTheaters
    case specialLists
    case favorites
    case addToFavorite
    case removeFromFavorite
    case chose
    case topRated
    case upcoming
    case popular
    case rating
    case letsAdd
    case noMoviesToList
    case choseSearchType
    case seeMore
    case similarMovies
   
    public enum SearchInput: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case all = "searchInput.all"
        case theater = "searchInput.theater"
        case search = "searchInput.search"
    }
}
