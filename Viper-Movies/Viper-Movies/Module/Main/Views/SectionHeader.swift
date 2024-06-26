//
//  SectionHeader.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 14.06.2024.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    static var reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String?) {
        sectionHeaderLabel.text = title ?? ""
    }
    
}



