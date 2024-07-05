//
//  BannerCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import UIKit

protocol BannerCellProtocol {
    func setImage(imagePath: String)
}

class BannerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var cellPresenter: BannerPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
}

extension BannerCell: BannerCellProtocol {
    func setImage(imagePath: String) {
        imageView.loadImage(with: imagePath)
    }
}


