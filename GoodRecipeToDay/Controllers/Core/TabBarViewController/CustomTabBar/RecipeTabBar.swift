//
//  RecipeTabBar.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.06.2023.
//

import UIKit

class RecipeTabBar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // Implement the delegate method to reload collection view
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            // Check if the selected view controller is your collection view controller
            if index == 3  {
                print(viewController.viewDidLoad())
                viewController.viewDidLoad()
            }
            
            if index == 4 {
                viewController.viewDidLoad()
                
            }
        }
    }
}
