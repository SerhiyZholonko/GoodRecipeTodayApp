//
//  MainViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


struct MainViewViewModel {
    public lazy var mainImage: URL? = {
        return URL(string: self.recipe.mainImage)
    }()
    public var title: String {
        return recipe.title
    }
    public var description: String {
        return recipe.description
    }
    public var ingredients: [Ingredient] {
        return recipe.ingredients
    }
    public var instruction: [Step] {
        return recipe.steps
    }
    public var fromUser: String {
        return "by \(recipe.username)"
    }
    public var time: String {
        return recipe.time
    }
    private let recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    
    //MARK: - Functions
    public func getIngredient(indexPath: IndexPath) -> Ingredient {
        return ingredients[indexPath.row]
    }
    public func getInstruction(indexPath: IndexPath) -> Step {
        return instruction[indexPath.row]
    }
}
