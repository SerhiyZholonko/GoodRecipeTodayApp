//
//  CategoryCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation

final class CategoryCellViewModel {
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
}
