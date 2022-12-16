//
//  TabBarViewController.swift
//  CatCat
//
//  Created by Ekko on 2022/09/11.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .bgBlack
        tabBar.barTintColor  = .bgBlack
        tabBar.isTranslucent = false
        
        let mainVC = MainViewController()
        let favoriteVC = FavoriteViewController()
        let myVC = MyViewController()
        
        mainVC.title = "Cats"
        favoriteVC.title = "Favorite"
        myVC.title = "My"
        
        mainVC.tabBarItem.image = UIImage(systemName: "house.fill")
        favoriteVC.tabBarItem.image = UIImage(systemName: "heart.fill")
        myVC.tabBarItem.image = UIImage(systemName: "square.and.arrow.up.fill")
        
        self.tabBar.tintColor = .systemRed
        
        self.viewControllers = [mainVC, favoriteVC, myVC]
        
    }
}
