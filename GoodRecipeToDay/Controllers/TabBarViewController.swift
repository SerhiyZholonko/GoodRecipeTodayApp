//
//  TabBarViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    let mainViewController = UINavigationController(rootViewController: MainViewController())
    let searchViewController =  UINavigationController(rootViewController: SearchViewController())
    let favoriteController = UINavigationController(rootViewController: FavoriteViewController())
    let profileViewController = UINavigationController(rootViewController: ProfileViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
      viewControllers = [
        mainViewController,
        searchViewController ,
        favoriteController,
        profileViewController
      ]
    }
    private func setControllers() {
        mainViewController.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        favoriteController.tabBarItem = UITabBarItem(title: "favorite", image: UIImage(systemName: "heart"), tag: 3)
        profileViewController.tabBarItem = UITabBarItem(title: "profile", image: UIImage(systemName: "person"), tag: 4)
        tabBar.tintColor = UIColor.red
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundColor = .systemBackground

    }

 

}
