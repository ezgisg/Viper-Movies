//
//  SecondPageViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit


protocol SecondPageDelegate: AnyObject {
    func startButtonClicked()
}

class SecondPageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: SecondPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "cinema")
    }

    @IBAction func startButton(_ sender: Any) {
        delegate?.startButtonClicked()
        print("Main screen e gidilecek")
    }
    
}

