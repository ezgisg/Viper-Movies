//
//  FavoritesTableViewCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import UIKit


protocol FavoritesTableViewCellProtocol: AnyObject {
    func setImage(imageUrlString: String)
    func setNameTitle(title: String)
}

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var cellPresenter: FavoritesCellPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with favorite: MovieFavoriteDetails) {
        let presenter = FavoritesCellPresenter(view: self, favorite: favorite)
        self.cellPresenter = presenter
    }
    
    
}

extension FavoritesTableViewCell: FavoritesTableViewCellProtocol {
    func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        movieImage.kf.indicatorType = .activity
        movieImage.contentMode = .scaleAspectFill
        movieImage.layer.cornerRadius = 10
        movieImage.kf.setImage(with: url) { result in
            switch result {
            case .success(let data):
                self.movieImage.image = data.image
            case .failure(let error):
                print("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                self.movieImage.image = UIImage(named: "noImage")
            }
        }
    }
    
    func setNameTitle(title: String) {
        movieTitleLabel.text = title
    }
    
    
}
