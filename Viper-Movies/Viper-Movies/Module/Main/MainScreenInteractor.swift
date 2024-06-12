//
//  MainScreenInteractor.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation

protocol MainScreenInteractorProtocol: AnyObject {
    
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    
}

final class MainScreenInteractor {
    var presenter: MainScreenPresenterProtocol?
    var output: MainScreenInteractorOutputProtocol?
}

extension MainScreenInteractor: MainScreenInteractorProtocol {
    
}
