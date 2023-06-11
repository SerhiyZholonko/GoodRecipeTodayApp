//
//  RecipesOfTheWeekCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import Foundation
import Firebase

final class RecipesOfTheWeekCellViewModel {
    //MARK: - Properties
    public var imageUrl: URL? {
        return URL(string: recipe.mainImage)
    }
    public var name: String {
        return recipe.title
    }
    public var createdDateString: String? {
        guard let timestamp: Timestamp = recipe.createdAt else { return nil }

        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"  // Customize the format according to your needs

        // Convert the Timestamp to a Date object
        let date = timestamp.dateValue()

        // Convert the Date to a string representation
        let dateString = dateFormatter.string(from: date)
        return "From \(dateString)"
    }
    //MARK: - Init
    private let recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
        recipe.createdAt?.dateValue()
    }
    //MARK: - Functions
}
