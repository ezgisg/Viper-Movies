//
//  BaseViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

// MARK: - BaseViewControllerProtocol
protocol BaseViewControllerProtocol: AnyObject {
    func showFailureAlert(error: BaseError)
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - BaseViewController
class BaseViewController: UIViewController, LoadingShowable {
    private var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    final func showAlert(title: String, message: String, buttonTitle: String = "Try Again", completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - BaseViewController: BaseViewControllerProtocol
extension BaseViewController: BaseViewControllerProtocol {
    final func showFailureAlert(error: BaseError) {
        showAlert(
            title: error.title,
            message: error.message,
            buttonTitle: "Ok",
            completion: nil
        )
    }
    
    final func showLoadingView() {
        showLoading()
    }
    
    final func hideLoadingView() {
        hideLoading()
    }
}

//MARK: Keyboard operations
///When keyboard is active then other tap properties disabled and when tap anywhere else but keyboard then keyboard hide
extension BaseViewController {
    final func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    
      @objc final func keyboardWillShow() {
          if tapGesture == nil {
              tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          }
          view.addGestureRecognizer(tapGesture)
      }
      
      @objc final func keyboardWillHide() {
          if tapGesture != nil {
              view.removeGestureRecognizer(tapGesture)
          }
      }
      @objc final func dismissKeyboard() {
          view.endEditing(true)
      }
}
