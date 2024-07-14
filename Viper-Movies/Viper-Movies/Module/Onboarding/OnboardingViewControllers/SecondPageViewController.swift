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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = .cinema
    }

    /// Triggers the `Let's Discover` button's action for routing the tabBar with `SecondPageDelegate`.
    @IBAction func startButton(_ sender: Any) {
        delegate?.startButtonClicked()
    }
}

