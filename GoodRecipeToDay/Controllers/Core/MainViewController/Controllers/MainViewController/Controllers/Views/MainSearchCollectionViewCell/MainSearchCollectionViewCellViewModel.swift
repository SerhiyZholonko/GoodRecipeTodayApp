//
//  SearchCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation


protocol MainSearchCollectionViewCellViewModelDelegate: AnyObject {
    func didSetUser(viewModel: MainSearchCollectionViewCellViewModel)
}

final class MainSearchCollectionViewCellViewModel {
    let coredataManager = CoreDataManager.shared
    let firebaseManager = FirebaseManager.shared
    weak var delegate: MainSearchCollectionViewCellViewModelDelegate?
    public var mainImageUrl: URL? {
        let url = URL(string: recipe.mainImage)
        return url
    }
    public var userUrl: URL? {
        guard let user = user else { return nil}
        return URL(string: user.urlString ?? "")
    }
    public  var title: String {
        return recipe.title
    }
    public var username: String {
        return recipe.username
    }
    private let recipe: Recipe

    private var user: GUser? {
        didSet {
            delegate?.didSetUser(viewModel: self)
        }
    }
    init(recipe: Recipe ){
        self.recipe = recipe
        getUser()
        
    }
     func getUser() {
        firebaseManager.getAllUsers {  users, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let users = users {
                for user in users {
                    print(user.username)
                    print(self.recipe.username)
                    if user.username == self.recipe.username {
                        self.user = user
                    }

                }
            }
            self.delegate?.didSetUser(viewModel: self)

        }
    }
    public func checkIsFavorite() -> Bool {
        let recipes: [CDRecipe] = CoreDataManager.shared.fetchData(entityName: "CDRecipe")
        for recipe in recipes {
            if recipe.id == self.recipe.key {
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
        guard !checkIsFavorite() else { return }
        let recipe = CDRecipe(context: CoreDataManager.shared.managedObjectContext)
        recipe.id = self.recipe.key
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
