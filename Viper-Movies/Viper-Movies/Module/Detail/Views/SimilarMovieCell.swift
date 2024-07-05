//
//  SimilarMovieCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit

protocol SimilarMovieCellProtocol: AnyObject {
    func setImage(imagePath: String)
    func setNameTitle(title: String)
}

class SimilarMovieCell: UICollectionViewCell {

    @IBOutlet weak var similarImageView: UIImageView!
    @IBOutlet weak var similarNameLabel: UILabel!
    
    var cellPresenter: SimilarMoviePresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
}

extension SimilarMovieCell: SimilarMovieCellProtocol {
    func setImage(imagePath: String) {
        similarImageView.loadImage(with: imagePath)
    }
    
    func setNameTitle(title: String) {
        similarNameLabel.text = title
    }
}
