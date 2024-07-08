//
//  String+Extensions.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 28.06.2024.
//

import Foundation

// MARK: - String Extension
extension String {
    ///To obtain string in desired date format
    func formatDate(from inputFormat: String, to outputFormat: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = outputFormat
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterSet.string(from: date)
        } else {
            return nil
        }
    }
    
    ///To convert string to url with using imageBase constant link
    var imageUrl: URL? {
        let urlString = "\(Constants.URLPaths.imageBase)\(self)"
        return URL(string: urlString)
    }
}
