//
//  FavoriteCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 31.05.2023.
//

import Foundation

final class FavoriteCollectionViewCellViewModel {
    public var title: String {
        return recipe.nameRecipe ?? "No name"
    }
    public var stringUrl: String {
        return recipe.stringImageURL ?? ""
    }
    //MARK: - Properties
    private let recipe: CDRecipe
    //MARK: - Init
    init(recipe: CDRecipe) {
        self.recipe = recipe
    }
    //MARK: - Functions
    
}
