//
//  SimilarMovieCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit

protocol SimilarMovieCellProtocol: AnyObject {
    func setImage(imageUrlString: String)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

extension SimilarMovieCell: SimilarMovieCellProtocol {
    func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        similarImageView.kf.indicatorType = .activity
        similarImageView.contentMode = .scaleAspectFill
        similarImageView.layer.cornerRadius = 10
        similarImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let data):
                self.similarImageView.image = data.image
            case .failure(let error):
                print("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                self.similarImageView.image = UIImage(named: "noImage")
            }
        }
        
    }
    
    func setNameTitle(title: String) {
        similarNameLabel.text = title
    }
    
}
