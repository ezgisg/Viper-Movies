//
//  ReachabilityManager.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 5.07.2024.
//

import Foundation
import Alamofire

// MARK: - ReachabilityManager
final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private init() { }
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "api.themoviedb.org")

    func startNetworkReachabilityObserver(completion: @escaping (Bool) -> Void ) {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable, .unknown:
                completion(false)
            case .reachable:
                completion(true)
            }
        }
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
