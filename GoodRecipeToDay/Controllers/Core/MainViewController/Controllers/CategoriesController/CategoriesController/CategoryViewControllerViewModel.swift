//
//  CategoryViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 24.05.2023.
//

import Foundation

protocol CategoryViewControllerViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

final class CategoryViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: CategoryViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    public var title: String {
        return category.title
    }
    var recipes: [Recipe] = [] {
        didSet {
            var newRecipes: [Recipe] = []
            for recipe in recipes {
                              if recipe.category == self.category.title {
                                  newRecipes.append(recipe)
                              }
                           }
            self.recipes = newRecipes
            self.delegate?.reloadCollectionView()
        }
    }
    private let category: Categories
    init(category: Categories) {
        self.category = category
        self.getingRecipes()
    }
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return recipes[indexParh.item]
    }
    private func getingRecipes() {
        firebaseManager.getAllRecipes { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
//                for recipe in recipes {
//                    if recipe.category == self?.category.title {
//                        self?.recipe.append(recipe)
//                    }
//                }
////                self.weekRecipe = weekRecipe.sorted { $0.craetedDate > $1.craetedDate }
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }

}
