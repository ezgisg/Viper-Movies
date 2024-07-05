//
//  BaseViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingShowable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, message: String, buttonTitle: String = "Try Again", completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
