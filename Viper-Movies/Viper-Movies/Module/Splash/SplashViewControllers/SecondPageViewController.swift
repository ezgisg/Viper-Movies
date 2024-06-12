//
//  SecondPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

class SecondPageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "cinema")
    }

    @IBAction func startButton(_ sender: Any) {
        //TODO: Root to main screen
        print("Main screen e gidilecek")
    }
    
}
