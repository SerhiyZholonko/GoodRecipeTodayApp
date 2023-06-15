//
//  SearchCollectionViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation

protocol MainSearchCollectionViewControllerViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

final class MainSearchCollectionViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: MainSearchCollectionViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared

    var searchText: String? {
        didSet {
            self.getingRecipes()
        }
    }
    var recipes: [Recipe] = [] {
        didSet {
            var newRecipes: [Recipe] = []
            for recipe in recipes {
                guard searchText != nil, let searchText = searchText else { return }
                if recipe.title.contains(searchText){
                                  newRecipes.append(recipe)
                              }
                           }
            self.recipes = newRecipes
            self.delegate?.reloadCollectionView()
        }
    }

    init() {
    self.getingRecipes()
    }
    public func updateSearchText(newText: String) {
        self.searchText = newText
    }
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return recipes[indexParh.item]
    }
    private func getingRecipes() {
        firebaseManager.getAllRecipes { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
                
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
   
}
