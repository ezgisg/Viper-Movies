//
//  EmptyView.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 28.06.2024.
//

import Foundation
import UIKit

// MARK: - EmptyView
class EmptyView: UIView, NibOwnerLoadable {
    
    private var contentView: UIView?
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var noMoviesText: UILabel!
    @IBOutlet weak var addText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageTapped))
           addImage.addGestureRecognizer(tapGesture)
           addImage.isUserInteractionEnabled = true
       }
       
       @objc private func addImageTapped() {
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController else {
               return
           }
           tabBarController.selectedIndex = 0
       }
    
   /*
    ///without NibOwnerLoadable extension
    private func commonInit() {
        if let nib = Bundle.main.loadNibNamed("EmptyView", owner: self)?.first as? UIView {
            contentView = nib
            contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView?.frame = bounds
            if let contentView {
                addSubview(contentView)
            }
        }

    }
    */
}


