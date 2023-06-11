//
//  RecomendViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import Foundation

protocol RecomendViewControllerViewModelDelegate: AnyObject {
    func didLoadRecipes(viewModel: RecomendViewControllerViewModel)
}

final class RecomendViewControllerViewModel {
    //MARK: - Properties
     weak var delegate: RecomendViewControllerViewModelDelegate?
    let title = "Redomend"
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
                let newRecipes = recipes.sorted { recipe1, recipe2 in
                    let rate1 = recipe1.rate ?? 0.0
                    let rate2 = recipe2.rate ?? 0.0
                    let counter1 = recipe1.rateCounter
                    let counter2 = recipe2.rateCounter

                    let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                    let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)

                    return value1 > value2
                }

                strongSelf.recipes = newRecipes
                strongSelf.delegate?.didLoadRecipes(viewModel: strongSelf)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
