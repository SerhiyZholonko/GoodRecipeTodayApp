//
//  SearchCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 27.05.2023.
//

import Foundation
import Firebase

final class SearchCollectionViewCellViewModel {
    //MARK: - Properties
    let firebaseManager = FirebaseManager.shared
    let coredataManager = CoreDataManager.shared
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
    public var createdDateString: String? {
        guard let timestamp: Timestamp = recipe.createdAt else { return nil }

        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"  // Customize the format according to your needs

        // Convert the Timestamp to a Date object
        let date = timestamp.dateValue()

        // Convert the Date to a string representation
        let dateString = dateFormatter.string(from: date)
        return "\(dateString)"
    }
    public var rate: String {
        var newRate = 0.0
        if recipe.rateCounter != 0, let rate = recipe.rate {
            newRate = rate.rounded(toDecimalPlaces: 1) / Double(recipe.rateCounter)
        }
        return "\(newRate.rounded(toDecimalPlaces: 1))(\(recipe.rateCounter))"
    }
    //PRivate
    private let recipe: Recipe
    //MARK: - Init
    init(recipe: Recipe ){
        self.recipe = recipe
    }
    
    public func checkIsFavorite() -> Bool {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
      
           
        guard let username = firebaseManager.mainUser?.username else { return false }
                for recipe in recipes {
                    guard let currentUsername = recipe.username else { return false }
                    if recipe.id == self.recipe.key, currentUsername == username {
                         // Unwrap and call the closure
                        return true
                    }
                }
          return false
    }
    public func deleteWithFavorite() {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        for recipe in recipes {
            if recipe.id == self.recipe.key {
                coredataManager.delete(recipe)
            }
        }
    }
    public func saveInCoredata() {
      
        guard let username = firebaseManager.mainUser?.username else { return }
            let recipe = CDRecipe(context: CoreDataManager.shared.managedObjectContext)
        recipe.id = self.recipe.key
        recipe.username = username
        recipe.nameRecipe = self.recipe.title
        recipe.rateCounter = Int16(self.recipe.rateCounter)
        recipe.stringImageURL = self.recipe.mainImage
        recipe.time = self.recipe.time
        recipe.numberOfSteps = Int16(self.recipe.steps.count)
        if let totalRate = self.recipe.rate {
            let currentRate = totalRate / Double(self.recipe.rateCounter)
                recipe.rate = currentRate
            }
            coredataManager.save(recipe)
        
    }
}
