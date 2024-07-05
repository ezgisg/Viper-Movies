//
//  Router.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let apiKey = ""
    
    case nowPlaying(page: Int?)
    case popular(page: Int?)
    case topRated(page: Int?)
    case upcoming(page: Int?)
    case details(movieId: Int32)
    case similar(page: Int?, movieId: Int32)
    case search(query: String, primary_release_year: String?, page: Int?)
  
    
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3/")
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "movie/now_playing"
        case .popular:
            return "movie/popular"
        case .topRated:
            return "movie/top_rated"
        case .upcoming:
            return "movie/upcoming"
        case .details(let movieId):
            return "movie/\(movieId)"
        case .similar(page: _, movieId: let movieId):
            return "movie/\(movieId)/similar"
        case .search:
            return "search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .nowPlaying, .popular, .topRated, .upcoming, .details, .similar, .search:
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
        case .similar(page: let page, movieId: _):
            if let page {
                params["page"] = page
            }
        case .search(query: let query, primary_release_year: let primary_release_year, page: let page):
            params["query"] = query
            if let page {
                params["page"] = page
            }
            if let primary_release_year {
                params["primary_release_year"] = primary_release_year
            }
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
            debugPrint("*** Request URL: ", request.url ?? "")
            return request
        } catch  {
            debugPrint("*** Error urlrequest: ", error)
            throw error
        }
    }
    
}
