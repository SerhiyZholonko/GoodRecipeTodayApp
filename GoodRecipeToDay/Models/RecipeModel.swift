//
//  RecipeModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import Foundation


struct RecipeModel {
    let title: String
    let category: String
    let description: String
    let creator: String
    let createdDate: Date = Date.now
    let image: String
    init(recipe: Recipe) {
        self.title = recipe.title
        self.category = recipe.category
        self.description = recipe.description
        self.creator = "Username"
        self.image = recipe.mainImage
    }
}
