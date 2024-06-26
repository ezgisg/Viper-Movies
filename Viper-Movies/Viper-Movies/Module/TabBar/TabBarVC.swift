//
//  TabBarVC.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//


import Foundation
import UIKit



class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    private func setupTabbar() {
        // MainViewController
        let mainVC = MainScreenRouter.createModule()
        mainVC.title = "In Theaters"
        let mainNavigationController = UINavigationController(rootViewController: mainVC)
        let mainImage = UIImage(named: "main")
        if let mainImage {
            let resizedMainImage = UIImage.resizeImage(image: mainImage, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
            mainNavigationController.tabBarItem = UITabBarItem(title: "In Theaters", image: resizedMainImage, tag: 0)
            
        }
        
        // SpecialViewController
        //TODO: will edit when special screen is ready
        let specialsVC = SpecialsRouter.createModule()
        specialsVC.title = "Special Lists"
        let specialsNavigationController = UINavigationController(rootViewController: specialsVC)
        
        let listImage = UIImage(named: "list")
        if let listImage {
            let resizedListImage = UIImage.resizeImage(image: listImage, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
            specialsNavigationController.tabBarItem = UITabBarItem(title: "Special Lists", image: resizedListImage, tag: 1)
            
        }
        
        // Favorites
        let favoritesVC = FavoritesRouter.createModule()
        favoritesVC.title = "Favorites"
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        let favoritesImage = UIImage(named: "favorites")
        if let favoritesImage {
            let resizedMainImage = UIImage.resizeImage(image: favoritesImage, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
            favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: resizedMainImage, tag: 0)
            
        }
        
        
        viewControllers = [mainNavigationController, specialsNavigationController, favoritesNavigationController]
        
        customizeTabBarAppearance()
        
    }
    
    private func customizeTabBarAppearance() {
        
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkestBrown]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.carrotOrange]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

//        tabBar.standardAppearance = tabBarAppearance
//        tabBar.scrollEdgeAppearance = tabBarAppearance
        
       }
}
