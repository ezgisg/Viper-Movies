//
//  BannerPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import Foundation
import Kingfisher

// MARK: - BannerPresenterProtocol
protocol BannerPresenterProtocol: AnyObject {
    func load()
}

// MARK: - BannerPresenter
final class BannerPresenter {
    let view: BannerCellProtocol?
    var movieResult: MovResult
    
    init(view: BannerCellProtocol?, movieResult: MovResult) {
        self.view = view
        self.movieResult = movieResult
    }
}

// MARK: - BannerPresenterProtocol
extension BannerPresenter: BannerPresenterProtocol {
    func load() {
        guard let path = movieResult.posterPath else {
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(Constants.URLPaths.imageBase)\(path)"
        view?.setImage(imagePath: fullUrl)
    }
}

