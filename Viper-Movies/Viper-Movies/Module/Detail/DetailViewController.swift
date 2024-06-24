//
//  DetailViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    
}

class DetailViewController: UIViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imdbImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: DetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieName.text = String(presenter?.movieId ?? 0)
     
    }
 
}
    

extension DetailViewController: DetailViewControllerProtocol {
    
}
