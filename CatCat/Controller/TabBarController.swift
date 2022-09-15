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
        
        let mainVC = MainViewController()
        let favoriteVC = FavoriteViewController()
        let myVC = MyViewController()
        
        mainVC.title = "Cats"
        favoriteVC.title = "Favorite"
        myVC.title = "My"
        
        let mainNC = UINavigationController(rootViewController: mainVC)
        //let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        //let myNC = UINavigationController(rootViewController: myVC)
        
        self.viewControllers = [mainNC, favoriteVC, myVC]
        
    }
}
