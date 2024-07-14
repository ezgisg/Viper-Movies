//
//  SplashInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

// MARK: - SplashInteractorProtocol
protocol SplashInteractorProtocol: AnyObject {
    func isConnected()
}

// MARK: - SplashInteractorOutputProtocol
protocol SplashInteractorOutputProtocol: AnyObject {
    func isConnectedOutput(_ status: Bool)
}

// MARK: - SplashInteractor
final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
    private let service = NetworkManager()
}

// MARK: - SplashInteractorProtocol
extension SplashInteractor: SplashInteractorProtocol {
    func isConnected() {
        let status = ReachabilityManager.shared.isConnectedToInternet()
        output?.isConnectedOutput(status)
    }
}
