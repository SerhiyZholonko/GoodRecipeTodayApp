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
    
    //MARK: - Functions
    
    public func saveInCoredata() {
        
//        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        let recipe = CDRecipe(context: CoreDataManager.shared.managedObjectContext)
        recipe.nameRecipe = self.recipe.title
        recipe.rateCounter = Int16(self.recipe.rateCounter)
        recipe.stringImageURL = self.recipe.mainImage
        recipe.time = self.recipe.time
        if let totalRate = self.recipe.rate {
            let currentRate = totalRate / Double(self.recipe.rateCounter)
            recipe.rate = currentRate
        }
        
        CoreDataManager.shared.save(recipe)
//            DataService.shared.setFavoriteStatus(for: title, with: false)
    }
}
