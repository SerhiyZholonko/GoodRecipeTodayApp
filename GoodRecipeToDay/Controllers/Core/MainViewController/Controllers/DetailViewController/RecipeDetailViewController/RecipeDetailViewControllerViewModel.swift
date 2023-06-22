//
//  RecipeDetailViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


class RecipeDetailViewControllerViewModel {
    
    let coredataManager = CoreDataManager.shared
    public var mainImageUrl: URL? {
        return URL(string: recipe.mainImage)
    }
    public var ingredients: [Ingredient]  {
        return recipe.ingredients
    }
    public var currentRecipe: Recipe {
        return recipe
    }
    public var step: [Step] {
        return recipe.steps
    }
    private var recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    //MARK: - Functions
    
    public func saveInCoredata() {
        guard !checkIsFavorite() else { return }
        let recipe = CDRecipe(context: CoreDataManager.shared.managedObjectContext)
        recipe.id = self.recipe.key
        recipe.nameRecipe = self.recipe.title
        recipe.rateCounter = Int16(self.recipe.rateCounter)
        recipe.stringImageURL = self.recipe.mainImage
        recipe.time = self.recipe.time
        recipe.numberOfSteps = Int16(self.recipe.steps.count)
        if let totalRate = self.recipe.rate {
            let currentRate = totalRate / Double(self.recipe.rateCounter)
            recipe.rate = currentRate
        }
        coredataManager.save(recipe)
    }
  
    public func checkIsFavorite() -> Bool {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        for recipe in recipes {
            if recipe.id == self.recipe.key {
                return true
            }
        }
        return false
    }
    public func deleteWithFavorite() {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        for recipe in recipes {
            if recipe.id == self.recipe.key {
                coredataManager.delete(recipe)
            }
        }
    }

}
