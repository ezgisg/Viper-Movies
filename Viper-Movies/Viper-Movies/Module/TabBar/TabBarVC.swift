//
//  TabBarVC.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import Foundation
import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
}

// MARK: - Functions
private extension TabBarController {
    final func setupTabbar() {
        /// MainViewController
        let mainVC = MainScreenRouter.createModule()
        let mainNavigationController = getStyledNavigationController(with: mainVC, title: "In Theaters", image: .main)
        
        /// SpecialViewController
        let specialsVC = SpecialsRouter.createModule()
        let specialsNavigationController = getStyledNavigationController(with: specialsVC, title: "Special Lists", image: .list)
        
        /// Favorites
        let favoritesVC = FavoritesRouter.createModule()
        let favoritesNavigationController = getStyledNavigationController(with: favoritesVC, title: "Favorites", image: .favorites)
        
        viewControllers = [mainNavigationController, specialsNavigationController, favoritesNavigationController]
        customizeTabBarAppearance()
    }
    
    final func getStyledNavigationController(with viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        viewController.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        let resizedImage = UIImage.resizeImage(image: image, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: 0)
        
        return navigationController
    }
    
    final func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkestBrown]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.backgroundColor = UIColor.systemGray6
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
