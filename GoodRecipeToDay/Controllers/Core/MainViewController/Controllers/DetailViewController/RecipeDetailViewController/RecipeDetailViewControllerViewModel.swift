//
//  RecipeDetailViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


protocol RecipeDetailViewControllerViewModelDelegate: AnyObject {
    func update(with viewModel: RecipeDetailViewControllerViewModel)
}

class RecipeDetailViewControllerViewModel {
    weak var delegate: RecipeDetailViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    let coredataManager = CoreDataManager.shared
    public var mainImageUrl: URL? {
        return URL(string: recipe.mainImage)
    }
    public var ingredients: [Ingredient]  {
        return recipe.ingredients
    }
    public var currentRecipe: Recipe {
        return recipe
    }
    public var step: [Step] {
        return recipe.steps
    }
     var username: String?
//    var isFavorite: ((Bool) -> Void)?

    private var recipe: Recipe
    init(recipe: Recipe) {
        self.recipe = recipe
        setUsername()
    }
    
    //MARK: - Functions
    
    private func setUsername() {
        firebaseManager.getCurrentUsername { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
                
            case .success(let username):
                strongSelf.username = username
                strongSelf.delegate?.update(with: strongSelf)
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       
    }
    public func saveInCoredata() {
        firebaseManager.fetchCurrentUser { [weak self] user in
            guard let username = user?.username, let strongSelf = self else { return }
            let recipe = CDRecipe(context: CoreDataManager.shared.managedObjectContext)
            recipe.id = strongSelf.recipe.key
            recipe.username = username
            recipe.nameRecipe = strongSelf.recipe.title
            recipe.rateCounter = Int16(strongSelf.recipe.rateCounter)
            recipe.stringImageURL = strongSelf.recipe.mainImage
            recipe.time = strongSelf.recipe.time
            recipe.numberOfSteps = Int16(strongSelf.recipe.steps.count)
            if let totalRate = strongSelf.recipe.rate {
                let currentRate = totalRate / Double(strongSelf.recipe.rateCounter)
                recipe.rate = currentRate
            }
            strongSelf.coredataManager.save(recipe)
            strongSelf.delegate?.update(with: strongSelf)
        }
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
                delegate?.update(with: self)
            }
        }
    }

}
