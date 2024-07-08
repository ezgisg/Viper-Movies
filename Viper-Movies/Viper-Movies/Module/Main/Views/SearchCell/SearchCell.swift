//
//  SearchCell.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 3.07.2024.
//

import UIKit

// MARK: - SearchCellProtocol
protocol SearchCellProtocol: AnyObject {
    func setName(name: String)
    func setYear(year: String)
}

// MARK: - SearchCell
final class SearchCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var cellPresenter: SearchPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with movie: MovResult) {
        let presenter = SearchPresenter(view: self, movie: movie)
        cellPresenter = presenter
    }
    
}

// MARK: - SearchCellProtocol
extension SearchCell: SearchCellProtocol {
    func setName(name: String) {
        movieNameLabel.text = name
    }
    
    func setYear(year: String) {
        yearLabel.text = year
    }
}
