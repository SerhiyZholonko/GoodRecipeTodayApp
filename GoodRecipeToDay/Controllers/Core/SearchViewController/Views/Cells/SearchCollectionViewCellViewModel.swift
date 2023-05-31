//
//  SearchCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 27.05.2023.
//

import Foundation

final class SearchCollectionViewCellViewModel {
    //MARK: - Properties
    //public
    public var mainImageUrl: URL? {
        let url = URL(string: recipe.mainImage)
        return url
    }
    public  var title: String {
        return recipe.title
    }
    public var time: String {
        if let minutesInt = recipe.time.convertToMinutes() {
            return "\(minutesInt)min"
        } else {
            return recipe.time
        }
    }
    public var rate: Double{
        if let allRateValue = recipe.rate {
            let currentRate = allRateValue / Double(recipe.rateCounter)
            return currentRate.rounded(toDecimalPlaces: 1)
        }
        return 0.0
    }
    //PRivate
    private let recipe: Recipe
    //MARK: - Init
    init(recipe: Recipe ){
        self.recipe = recipe
    }
}
