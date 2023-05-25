//
//  AddIngredientTableViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.05.2023.
//

import Foundation

struct AddIngredientTableViewCellViewModel: Equatable {
    let id = UUID().uuidString
    var ingredient: String
        
    mutating func updateIngredient(newValve: String) {
        ingredient = newValve
    }

}
