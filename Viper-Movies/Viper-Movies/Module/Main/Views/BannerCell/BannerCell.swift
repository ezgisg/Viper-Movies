//
//  BannerCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import UIKit
import Kingfisher

protocol BannerCellProtocol {
    func setImage(imageUrlString: String)

}

class BannerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    
    var cellPresenter: BannerPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

extension BannerCell: BannerCellProtocol {
    
    func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let data):
                self.imageView.image = data.image
            case .failure(let error):
                print("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                self.imageView.image = UIImage(named: "noImage")
            }
        }
    }
}


