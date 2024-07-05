//
//  BannerPresenter.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 13.06.2024.
//

import Foundation
import Kingfisher


protocol BannerPresenterProtocol: AnyObject {
    func load()
}

final class BannerPresenter {
    let view: BannerCellProtocol?
    var movieResult: MovResult
    
    init(view: BannerCellProtocol?, movieResult: MovResult) {
        self.view = view
        self.movieResult = movieResult
    }
}

extension BannerPresenter: BannerPresenterProtocol {
    func load() {
        let imageBaseUrl = "https://image.tmdb.org/t/p/w500/"
        guard let path = movieResult.posterPath else {
            view?.setImage(imagePath: "")
            return }
        let fullUrl = "\(imageBaseUrl)\(path)"
        view?.setImage(imagePath: fullUrl)
    }

}

