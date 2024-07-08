//
//  onboardingInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import Foundation

// MARK: - onboardingInteractorProtocol
protocol OnboardingInteractorProtocol: AnyObject {
    func isConnected()
}

// MARK: - onboardingInteractorOutputProtocol
protocol onboardingInteractorOutputProtocol: AnyObject {
    func isConnectedOutput(_ status: Bool)
}

// MARK: - onboardingInteractor
final class onboardingInteractor {
    var output: onboardingInteractorOutputProtocol?
    fileprivate let service = NetworkManager()

}

// MARK: - onboardingInteractor
extension onboardingInteractor: OnboardingInteractorProtocol {
    func isConnected() {
        let status = service.isConnectedToInternet()
        output?.isConnectedOutput(status)
    }
}
