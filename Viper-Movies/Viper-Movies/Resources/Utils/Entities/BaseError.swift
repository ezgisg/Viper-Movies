//
//  BaseError.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 5.07.2024.
//

import Foundation

enum BaseError: Error {
    case decoding
    case badRequest
    case auth
    case forbidden
    case notFound
    case invalidMethod
    case timeout
    case requestCancelled
    case internalServerError
    case unknown
    
    var title: String {
        switch self {
        case .decoding:
            "Decoding Error"
        case .badRequest:
            "Bad Request Error"
        case .auth:
            "Authorization Error"
        case .forbidden:
            "Forbidden Error"
        case .notFound:
            "Not Found Error"
        case .invalidMethod:
            "Invalid Method Error"
        case .timeout:
            "Time Out Error"
        case .requestCancelled:
            "Request Cancelled Error"
        case .internalServerError:
            "Internal Server Error"
        case .unknown:
            "Unknown Error"
        }
    }
    
    var message: String {
        switch self {
        case .decoding:
            "Decoding Error Message"
        case .badRequest:
            "Bad Request Error Message"
        case .auth:
            "Authorization Error Message"
        case .forbidden:
            "Forbidden Error Message"
        case .notFound:
            "Not Found Error Message"
        case .invalidMethod:
            "Invalid Method Error Message"
        case .timeout:
            "Time Out Error Message"
        case .requestCancelled:
            "Request Cancelled Error Message"
        case .internalServerError:
            "Internal Server Error Message"
        case .unknown:
            "Unknown Error Message"
        }
    }
}
