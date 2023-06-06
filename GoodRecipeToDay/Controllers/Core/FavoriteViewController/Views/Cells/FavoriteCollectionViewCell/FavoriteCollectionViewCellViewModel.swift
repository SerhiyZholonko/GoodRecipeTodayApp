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
    public var rate: String {
        var newRate = 0.0
        if recipe.rateCounter != 0 {
            newRate = recipe.rate.rounded(toDecimalPlaces: 1)
        }
        return "\(newRate)(\(recipe.rateCounter))"
    }
    public var time: String {
        return recipe.time?.convertToTimeFormat() ?? "0:00"
    }
    public var numberOfSteps: String {
        return "\(recipe.numberOfSteps) Steps"
    }
    public var complexity: String {
        switch recipe.numberOfSteps {
        case 0...4:
            return "Eazy"
        case 4...8:
            return "Medion"
        case 8...20:
            return "Hard"
        default:
            return ""
        }
    }
    //MARK: - Properties
    private let recipe: CDRecipe
    //MARK: - Init
    init(recipe: CDRecipe) {
        self.recipe = recipe
    }
    //MARK: - Functions
    
    
    
}
