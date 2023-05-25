//
//  WeekViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import Foundation
import Firebase


final class WeekViewCellViewModel {
    public var title: String {
        return weekRecipe.title
    }
    public var imageUrl: URL? {
        return URL(string: weekRecipe.mainImage)
    }
    public var username: String {
        return "By \(weekRecipe.username)" 
    }
    public var craetedDate: Date {
        return weekRecipe.createdAt?.dateValue() ??  Timestamp(date: Date()).dateValue()
    }
    public var createdDateString: String? {
        guard let timestamp: Timestamp = weekRecipe.createdAt else { return nil }

        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"  // Customize the format according to your needs

        // Convert the Timestamp to a Date object
        let date = timestamp.dateValue()

        // Convert the Date to a string representation
        let dateString = dateFormatter.string(from: date)
        return "From \(dateString)"
    }
    public var recipe: Recipe {
        return weekRecipe
    }
    private let weekRecipe: Recipe
    init(weekRecipe: Recipe) {
        self.weekRecipe = weekRecipe
    }
}
