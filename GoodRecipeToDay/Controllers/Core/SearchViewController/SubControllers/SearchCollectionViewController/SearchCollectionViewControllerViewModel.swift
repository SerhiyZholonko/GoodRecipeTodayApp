//
//  SearchCollectionViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 27.05.2023.
//

import Foundation
import Firebase

protocol SearchCollectionViewControllerViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

final class SearchCollectionViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: SearchCollectionViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    public var type: CheckmarkTextViewType {
        return typeForFilter
    }
    var searchText: String? {
        didSet {
            self.getingRecipes()
        }
    }
    var recipes: [Recipe] = [] {
        didSet {
            var newRecipes: [Recipe] = []
            guard  searchText != nil,  let searchText = searchText else { return }
            for recipe in recipes {
                if recipe.title.contains(searchText){
                                  newRecipes.append(recipe)
                              }
                           }
            self.recipes = newRecipes
            self.delegate?.reloadCollectionView()
        }
    }
   
    private var isRevers: Bool = false
    private var typeForFilter: CheckmarkTextViewType = .date

    //MARK: - Init

    init() {}
    //MARK: - Functions
    public func changeRevers() {
        isRevers.toggle()
        getingRecipes()
    }
    public func setupType(type: CheckmarkTextViewType) {
        self.typeForFilter = type
        getingRecipes()
    }
    public func updateSearchText(newText: String) {
        self.searchText = newText
    }
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return recipes[indexParh.item]
    }
     private func getingRecipes() {
        switch typeForFilter {
        case .all:
            firebaseManager.getAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    //TODO: - filter recomend
                case .failure(_):
                    print("error recomendRecipes")
                }
            }
        case .rate:

            firebaseManager.getAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    let newRecipes = recipes.sorted { [weak self] recipe1, recipe2 in
                        guard let strongsSelf = self else { return false}
                        let rate1 = recipe1.rate ?? 0.0
                        let rate2 = recipe2.rate ?? 0.0
                        let counter1 = recipe1.rateCounter
                        let counter2 = recipe2.rateCounter

                        let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                        let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)

                        return strongsSelf.isRevers ? value1 > value2 : value1 < value2
                    }

                    self?.recipes = newRecipes

                    // TODO: - filter recomend
                case .failure(_):
                    print("error recomendRecipes")
                }
            }
        case .time:
            firebaseManager.getAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    let newRecipes = recipes.sorted{ [weak self] in
                        guard let strongsSelf = self else { return false}
                        return strongsSelf.isRevers ? $0.time < $1.time : $0.time > $1.time
                    }
                    self?.recipes = newRecipes
                    //TODO: - filter recomend
                case .failure(_):
                    print("error recomendRecipes")
                }
            }
        case .date:

            firebaseManager.getAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    let newRecipes = recipes.sorted { [weak self] recipe1, recipe2 in
                        guard let strongsSelf = self else { return false}
                        if let createdAt1 = recipe1.createdAt, let createdAt2 = recipe2.createdAt {
                            return strongsSelf.isRevers ? createdAt1 < createdAt2 : createdAt1 > createdAt2
                        } else {
                            // Handle the case where createdAt is nil for either recipe
                            // You can decide how to handle this scenario based on your requirements
                            return false
                        }
                    }
                    self?.recipes = newRecipes
                    // TODO: - filter recommendation
                case .failure(_):
                    print("Error getting recipes")
                }
            }

        }
     

    }
}
 