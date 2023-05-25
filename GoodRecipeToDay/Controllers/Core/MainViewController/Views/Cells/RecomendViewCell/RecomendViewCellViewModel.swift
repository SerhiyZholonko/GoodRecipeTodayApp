//
//  RecomendViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import Foundation
import Firebase


final class RecomendViewCellViewModel {
    public var imageUrl: URL? {
        return URL(string: recomendRecipe.mainImage)
    }
   
    public var title: String {
        return recomendRecipe.title
    }
    public var usernmae: String {
        return recomendRecipe.username
    }
    public var recipe: Recipe {
        return recomendRecipe
    }
    private let recomendRecipe: Recipe
    init(recomendRecipe: Recipe) {
        self.recomendRecipe = recomendRecipe
        
//        print(recomendRecipe.createdAt ?? "nil")
    }
}
