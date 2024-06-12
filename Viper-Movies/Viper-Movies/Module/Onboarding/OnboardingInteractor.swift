//
//  onboardingInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

protocol onboardingInteractorProtocol: AnyObject {
    func isConnected()
}

protocol onboardingInteractorOutputProtocol: AnyObject {
    func isConnectedOutput(_ status: Bool)
}

final class onboardingInteractor {
    var output: onboardingInteractorOutputProtocol?
    fileprivate let service = NetworkManager()

}

extension onboardingInteractor: onboardingInteractorProtocol {
    func isConnected() {
        let status = service.isConnectedToInternet()
        self.output?.isConnectedOutput(status)
    }
}
