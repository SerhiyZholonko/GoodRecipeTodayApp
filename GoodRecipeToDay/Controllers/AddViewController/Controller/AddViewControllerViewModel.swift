//
//  AddViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

struct AddViewControllerViewModel {
    let title = "Adding"
    var ingregients = [AddIngredientTableViewCellViewModel]()
    var instructions = [CookingTableViewCellViewModel]()
    init() {
        addIngredients()
        addInstructions()
    }
    mutating func addInstructions() {
    
        let newInstructions = CookingTableViewCellViewModel(instruction: "", image: UIImage(named: "add"))
        self.instructions.append(newInstructions)
    }
    
   private mutating func addIngredients() {
        let newIngredients = [AddIngredientTableViewCellViewModel(ingredient: "2 eggs"), AddIngredientTableViewCellViewModel(ingredient: "100g wather")]
        self.ingregients.append(contentsOf: newIngredients)
    }
    mutating func addOneInfredient() {
        let newIngredient = AddIngredientTableViewCellViewModel(ingredient: "quantity / product")
        self.ingregients.append(newIngredient)
    }
}
