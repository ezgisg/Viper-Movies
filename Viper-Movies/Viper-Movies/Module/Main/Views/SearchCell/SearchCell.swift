//
//  SearchCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 3.07.2024.
//

import UIKit

protocol SearchCellProtocol: AnyObject {
    func setName(name: String)
    func setYear(year: String)
}

class SearchCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var cellPresenter: SearchPresenter? {
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
    
    func configure(with movie: MovResult) {
        let presenter = SearchPresenter(view: self, movie: movie)
        self.cellPresenter = presenter
    }
    
}

extension SearchCell: SearchCellProtocol {
    func setName(name: String) {
        movieNameLabel.text = name
    }
    
    func setYear(year: String) {
        yearLabel.text = year
    }
    
}
