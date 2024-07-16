//
//  FirstPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

// MARK: - FirstPageViewController
class FirstPageViewController: BaseViewController {
    @IBOutlet weak var onboardingMessage: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let videoGif = UIImage.gifImageWithName("movieGif")
        imageView.image = videoGif
        onboardingMessage.text = L10n.onboardingFirstMessage.localized()
    }
}
