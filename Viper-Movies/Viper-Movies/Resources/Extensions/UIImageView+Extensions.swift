//
//  UIImageView+Extensions.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 5.07.2024.
//

import Foundation
import UIKit.UIImageView
import Kingfisher

///To load image from url with KF
extension UIImageView {
    func loadImage(with path: String, cornerRadius: CGFloat = 10) {
        kf.indicatorType = .activity
        contentMode = .scaleToFill
        layer.cornerRadius = cornerRadius
        kf.setImage(with: path.imageUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                image = data.image
            case .failure(let error):
                debugPrint("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                image = UIImage(named: "noImage")
            }
        }
    }
}
