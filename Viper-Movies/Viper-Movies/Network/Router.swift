//
//  Router.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let apiKey = "e6055b472537ec47f98dfc79860288d4"
    
    case nowPlaying(page: Int?)
    case popular(page: Int?)
    case topRated(page: Int?)
    case upcoming(page: Int?)
    case details(movieId: Int32)
    
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3/movie/")
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        case .details(let movieId):
            return "\(movieId))"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .nowPlaying, .popular,.topRated, .upcoming, .details:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: Parameters = [:]
        switch self {
        case .nowPlaying(page: let page):
            if let page {
                params["page"] = page
            }
        case .popular(page: let page):
            if let page {
                params["page"] = page
            }
        case .topRated(page: let page):
            if let page {
                params["page"] = page
            }
        case .upcoming(page: let page):
            if let page {
                params["page"] = page
            }
        case .details:
            return nil
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch method {
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURL else {throw URLError(.badURL)}
        var urlRequest = URLRequest(url: baseURL.appending(path: path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var completeParameters = parameters ?? [:]
        completeParameters["api_key"] = Router.apiKey
        
        do {
            let request = try encoding.encode(urlRequest, with: completeParameters)
            debugPrint("*** MY URL: ", request.url ?? "")
            return request
        } catch  {
            debugPrint("*** Error urlrequest: ", error)
            throw error
        }
    }
    
}
