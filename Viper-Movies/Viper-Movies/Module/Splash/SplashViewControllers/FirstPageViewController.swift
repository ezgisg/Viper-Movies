//
//  FirstPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

class FirstPageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoGif = UIImage.gifImageWithName("video-channel")
        self.imageView.image = videoGif
    }
    
    @IBAction func skipButton(_ sender: Any) {
        //TODO: Root to main view
        print("Skip butonuna basıldı")
    }
    
}
