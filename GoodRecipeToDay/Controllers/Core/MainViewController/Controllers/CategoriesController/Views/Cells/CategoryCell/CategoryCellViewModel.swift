//
//  CategoryCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation

protocol CategoryCellViewModelDelegate: AnyObject {
    func reloadCollection(viewModel: CategoryCellViewModel)
}

final class CategoryCellViewModel {
    weak var delegate: CategoryCellViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    let coredataManager = CoreDataManager.shared
    public var mainImageUrl: URL? {
        let url = URL(string: recipe.mainImage)
        return url
    }

    public  var title: String {
        return recipe.title
    }
    public var username: String {
        return recipe.username
    }
    public var userPhotoUrl: URL? {
        guard let user = user else { return nil }
        return URL(string: user.urlString ?? "")
    }
    private let recipe: Recipe
    private var user: GUser?
    init(recipe: Recipe ){
        self.recipe = recipe
        getUser()
    }
    private func getUser() {
        firebaseManager.getUserFromUsername(username: recipe.username) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                guard let strongSelf = self else { return }
                self?.delegate?.reloadCollection(viewModel: strongSelf)
            case .failure(let error):
                print(error.localizedDescription)
            }
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
