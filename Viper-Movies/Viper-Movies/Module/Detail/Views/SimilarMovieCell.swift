//
//  SimilarMovieCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit

// MARK: - SimilarMovieCellProtocol
protocol SimilarMovieCellProtocol: AnyObject {
    func setImage(imagePath: String)
    func setNameTitle(title: String)
}

// MARK: - SimilarMovieCell
class SimilarMovieCell: UICollectionViewCell {
    @IBOutlet private weak var similarImageView: UIImageView!
    @IBOutlet private weak var similarNameLabel: UILabel!
    
    var cellPresenter: SimilarMoviePresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
}

// MARK: - SimilarMovieCellProtocol
extension SimilarMovieCell: SimilarMovieCellProtocol {
    func setImage(imagePath: String) {
        similarImageView.loadImage(with: imagePath)
    }
    
    func setNameTitle(title: String) {
        similarNameLabel.text = title
    }
}
