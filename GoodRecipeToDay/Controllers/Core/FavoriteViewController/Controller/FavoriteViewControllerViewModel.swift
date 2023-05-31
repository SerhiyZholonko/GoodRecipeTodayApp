//
//  FavoriteViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation

struct FavoriteViewControllerViewModel {
    //MARK: - Properties
    let title = "here are the best recipes"
     var recipes: [CDRecipe] = []
    //MARK: - Init
    init() {
        configure()
    }
    //MARK: - Functions
    public mutating func configure() {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        self.recipes = recipes
    }
}
