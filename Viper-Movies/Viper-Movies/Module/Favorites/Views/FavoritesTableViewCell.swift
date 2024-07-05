//
//  FavoritesTableViewCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 27.06.2024.
//

import UIKit


protocol FavoritesTableViewCellProtocol: AnyObject {
    func setImage(imagePath: String)
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
    func setImage(imagePath: String) {
        movieImage.loadImage(with: imagePath)
    }
    
    func setNameTitle(title: String) {
        movieTitleLabel.text = title
    }
}
