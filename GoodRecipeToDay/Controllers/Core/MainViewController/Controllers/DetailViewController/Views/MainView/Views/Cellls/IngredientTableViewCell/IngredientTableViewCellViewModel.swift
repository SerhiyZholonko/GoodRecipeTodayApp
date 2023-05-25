//
//  IngredientTableViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation

struct IngredientTableViewCellViewModel {
    public var title: String {
        return ingredient.title
    }
    private var ingredient: Ingredient
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
}
