//
//  MainScreenViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import UIKit

protocol MainScreenViewControllerProtocol: AnyObject {
    
}

class MainScreenViewController: UIViewController {
    
    var presenter: MainScreenPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }


}

extension MainScreenViewController: MainScreenViewControllerProtocol {
    
}


//for image download base url: https://image.tmdb.org/t/p/original/
