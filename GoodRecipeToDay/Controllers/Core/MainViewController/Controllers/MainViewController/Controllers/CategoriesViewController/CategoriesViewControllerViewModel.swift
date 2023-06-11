//
//  CategoriesViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import Foundation

class CategoriesViewControllerViewModel {
    //MARK: - Properties
    let title = "Categories"
    let allCategories = Categories.allCases
    //MARK: - Init
    
    //MARK: - Functions
    public func getCategory(by indexPath: IndexPath) -> Categories {
        return allCategories[indexPath.item]
    }
}
