//
//  MyReipeCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.06.2023.
//

import Foundation
import Firebase


final class MyReipeCollectionViewCellViewModel {
    //MARK: - Properties
    let firebaseManager = FirebaseManager.shared
    
    public var title: String {
        return recipe.title
    }
    public var url: URL? {
        return URL(string: recipe.mainImage)
    }
    private var dataString: Date {
        return recipe.createdAt?.dateValue() ??  Timestamp(date: Date()).dateValue()
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
    private let recipe: Recipe
    //MARK: - Init
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    //MARK: - Functions

}

