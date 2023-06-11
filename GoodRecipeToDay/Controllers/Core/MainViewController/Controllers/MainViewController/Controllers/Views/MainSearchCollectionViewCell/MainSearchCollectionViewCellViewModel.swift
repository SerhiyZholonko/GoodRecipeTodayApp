//
//  SearchCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation


final class MainSearchCollectionViewCellViewModel {
    let coredataManager = CoreDataManager.shared

    public var mainImageUrl: URL? {
        let url = URL(string: recipe.mainImage)
        return url
    }
    public  var title: String {
        return recipe.title
    }
    public var username: String {
        return recipe.username
    }
    private let recipe: Recipe
    init(recipe: Recipe ){
        self.recipe = recipe
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
}
