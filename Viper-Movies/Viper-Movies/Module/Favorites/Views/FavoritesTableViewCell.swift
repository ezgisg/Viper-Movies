//
//  FavoritesTableViewCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import UIKit

// MARK: - FavoritesTableViewCellProtocol
protocol FavoritesTableViewCellProtocol: AnyObject {
    func setImage(imagePath: String)
    func setNameTitle(title: String)
}

// MARK: - FavoritesTableViewCell
final class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    
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
}

// MARK: - FavoritesTableViewCellProtocol
extension FavoritesTableViewCell: FavoritesTableViewCellProtocol {
    func setImage(imagePath: String) {
        movieImage.loadImage(with: imagePath)
    }
    
    func setNameTitle(title: String) {
        movieTitleLabel.text = title
    }
}

// MARK: - Helpers
extension FavoritesTableViewCell {
    func configure(with favorite: MovieFavoriteDetails) {
        let presenter = FavoritesCellPresenter(view: self, favorite: favorite)
        self.cellPresenter = presenter
    }
}
