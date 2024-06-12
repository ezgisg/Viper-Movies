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
