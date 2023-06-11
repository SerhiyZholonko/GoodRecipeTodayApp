//
//  RecomendCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import Foundation


struct RecomendCollectionViewCellViewModel {
    
    //MARK: - Properties
    public var imageUrl: URL? {
        return URL(string: recipe.mainImage)
    }
    public var title: String {
        return recipe.title
    }
    public var time: String {
        return recipe.time.convertToTimeFormat()
    }
    public var rate: String {
        var newRate = 0.0
        if recipe.rateCounter != 0, let rate = recipe.rate {
            newRate = rate.rounded(toDecimalPlaces: 1) / Double(recipe.rateCounter)
        }
        return "\(newRate.rounded(toDecimalPlaces: 1))(\(recipe.rateCounter))"
    }
    public var numberOfSteps: String {
        return "\(recipe.steps.count) Steps"
    }
    public var complexity: String {
        switch recipe.steps.count {
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
    private let recipe: Recipe
    //MARK: - Init
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    //MARK: - Functions
}
