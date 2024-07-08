//
//  BannerCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import UIKit

// MARK: - BannerCellProtocol
protocol BannerCellProtocol {
    func setImage(imagePath: String)
}

// MARK: - BannerCell
class BannerCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var cellPresenter: BannerPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
}

// MARK: - BannerCellProtocol
extension BannerCell: BannerCellProtocol {
    func setImage(imagePath: String) {
        imageView.loadImage(with: imagePath)
    }
}


