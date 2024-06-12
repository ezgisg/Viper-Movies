//
//  SplashViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import UIKit


protocol SplashViewControllerProtocol: AnyObject {
    func makeAlert(title: String, message: String)
}


class SplashViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    var presenter: SplashPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "movie")
    }
    override func viewDidAppear(_ animated: Bool) {
        presenter?.checkConnection()
    }

}

extension SplashViewController: SplashViewControllerProtocol {
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message) {
            self.presenter?.checkConnection()
        }
    }
}
