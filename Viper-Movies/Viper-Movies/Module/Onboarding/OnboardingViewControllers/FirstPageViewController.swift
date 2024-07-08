//
//  FirstPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

// MARK: - FirstPageViewController
class FirstPageViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoGif = UIImage.gifImageWithName("movieGif")
        imageView.image = videoGif
    }
}
