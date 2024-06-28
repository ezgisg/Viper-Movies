//
//  MovieCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import UIKit

protocol MovieCellProtocol: AnyObject {
    func setTitle(title: String)
    func setDescription(description: String)
    func setDetail(detail: String)
    func setImage(imageUrlString: String)
}

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var cellPresenter: MoviePresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension MovieCell: MovieCellProtocol {

    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setDescription(description: String) {
        descriptionLabel.text = description
    }
    
    func setDetail(detail: String) {
        detailLabel.text = detail.formatDate(from: "yyyy-MM-dd", to: "dd-MM-yyyy")
    }
    
    func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
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
