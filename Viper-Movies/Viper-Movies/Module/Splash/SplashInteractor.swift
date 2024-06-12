//
//  SplashInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol SplashInteractorProtocol: AnyObject {
    func isConnected()
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func isConnectedOutput(_ status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
    fileprivate let service = NetworkManager()
}

extension SplashInteractor: SplashInteractorProtocol {
    func isConnected() {
        let status = service.isConnectedToInternet()
        self.output?.isConnectedOutput(status)
    }
}
