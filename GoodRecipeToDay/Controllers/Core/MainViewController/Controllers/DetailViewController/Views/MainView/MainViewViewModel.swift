//
//  MainViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


final class MainViewViewModel {
    let firebaseManager = FirebaseManager.shared
    ///MARK: - Pulic
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
    public var rate: Double {
       let bigRate = recipe.rate ?? 0.0
        if recipe.rateCounter != 0  {
            let newRate = bigRate / Double(recipe.rateCounter)
            return newRate
        } else  {
            return 0
        }
    }
    //MARK: - Private
    private var recipeIdForUser: String?
    
    private let recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    //MARK: - Functions
    public func updateRecipeRate(rate: Double) {
        
        updateRecipeForUser(newRate: rate)
    }
    
    public func getIngredient(indexPath: IndexPath) -> Ingredient {
        return ingredients[indexPath.row]
    }
    public func getInstruction(indexPath: IndexPath) -> Step {
        return instruction[indexPath.row]
    }
    
    //MARK: - Private functions
     func getRecipeIDForUser() {
        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) {[weak self] result in
            switch result {
            case .success(let id):
                self?.recipeIdForUser = id
                print("ID: ",id)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func updateRecipeForUser(newRate: Double) {
        getRecipeIDForUser()

        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) {[weak self] result in
            switch result {
            case .success(let id):
                guard let strongSelf = self else { return }
                strongSelf.firebaseManager.updateRecipeForUser(username: strongSelf.recipe.username, recipeID: id, newRate: newRate, recipe: strongSelf.recipe) { error in
                    if let error = error {
                           print("Failed to update recipe rate: \(error)")
                       } else {
                           print("Recipe rate updated successfully.")
                       }
                }
            case .failure(let error):
                print(error)
            }
        }
     
    }
    
}
