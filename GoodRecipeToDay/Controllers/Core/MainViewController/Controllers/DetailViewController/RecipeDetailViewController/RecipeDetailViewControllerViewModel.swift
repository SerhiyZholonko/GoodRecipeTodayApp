//
//  RecipeDetailViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


class RecipeDetailViewControllerViewModel {
    public var mainImageUrl: URL? {
        return URL(string: recipe.mainImage)
    }
    public var ingredients: [Ingredient]  {
        return recipe.ingredients
    }
    public var currentRecipe: Recipe {
        return recipe
    }
    private var recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
