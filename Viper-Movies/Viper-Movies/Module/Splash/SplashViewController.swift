//
//  SplashViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import UIKit

// MARK: - SplashViewControllerProtocol
protocol SplashViewControllerProtocol: AnyObject {
    func makeAlert(title: String, message: String)
}

// MARK: - SplashViewController
class SplashViewController: BaseViewController {
    @IBOutlet private weak var imageView: UIImageView!
    var presenter: SplashPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = .movie
    }
    override func viewDidAppear(_ animated: Bool) {
        presenter?.checkConnection()
    }
}

// MARK: - SearchResultInteractorOutputProtocol
extension SplashViewController: SplashViewControllerProtocol {
    ///To check connection status and if there is not then show alert
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message) { [weak self] in
            guard let self else { return }
            presenter?.checkConnection()
        }
    }
}
