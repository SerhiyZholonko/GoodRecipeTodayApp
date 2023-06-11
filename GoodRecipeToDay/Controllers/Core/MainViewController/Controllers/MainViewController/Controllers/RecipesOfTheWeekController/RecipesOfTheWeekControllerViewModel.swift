//
//  RecipesOfTheWeekControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import Foundation
import Firebase


protocol RecipesOfTheWeekControllerViewModelDelegate: AnyObject {
    func didLoadRecipes(viewModel: RecipesOfTheWeekControllerViewModel)
}

final class RecipesOfTheWeekControllerViewModel {
    //MARK: - Properties
    weak var delegate: RecipesOfTheWeekControllerViewModelDelegate?
    let title = "The Week"
    let firebaseManager = FirebaseManager.shared
    private var recipes: [Recipe] = []

    //MARK: - Init
    init() {
        fetchRecipies()
    }
    //MARK: - Functions
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return recipes[indexParh.item]
    }
    public func getRecipesCount() -> Int {
        return recipes.count
    }
    private func fetchRecipies() {
        firebaseManager.getAllRecipes { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
                
            case .success(let recipes):
                let newRecipes = recipes.sorted  {
                    $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date())
                }

                strongSelf.recipes = newRecipes
                strongSelf.delegate?.didLoadRecipes(viewModel: strongSelf)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
