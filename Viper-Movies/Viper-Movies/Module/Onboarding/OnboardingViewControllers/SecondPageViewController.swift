//
//  SecondPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

// MARK: - SecondPageDelegate
protocol SecondPageDelegate: AnyObject {
    func startButtonClicked()
}

// MARK: - SecondPageViewController
class SecondPageViewController: BaseViewController {
    @IBOutlet private weak var imageView: UIImageView!
    weak var delegate: SecondPageDelegate?
    @IBOutlet weak var onboardingMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = .cinema
        onboardingMessage.text = L10n.onboardingSecondMessage.localized()
    }

    /// Triggers the `Let's Discover` button's action for routing the tabBar with `SecondPageDelegate`.
    @IBAction func startButton(_ sender: Any) {
        delegate?.startButtonClicked()
    }
}

