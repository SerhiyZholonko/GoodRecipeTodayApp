//
//  SearchCollectionViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import Foundation
import Firebase


protocol MainSearchCollectionViewControllerViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

final class MainSearchCollectionViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: MainSearchCollectionViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    private var pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    var searchText: String? {
        didSet {
            self.getingRecipes()
        }
    }
    public var isLastRecipe: Bool = false
    var filteredData: [Recipe] = []
    var dataSource: [Recipe] = [] {
        didSet {
            var newRecipes: [Recipe] = []
            for recipe in dataSource {
                guard searchText != nil, let searchText = searchText else { return }
                if recipe.title.contains(searchText){
                                  newRecipes.append(recipe)
                              }
                           }
            self.dataSource = newRecipes
            self.delegate?.reloadCollectionView()
        }
    }
    private var isRevers: Bool = false {
        didSet {
            getingRecipes()
        }
    }
    init() {
    self.getingRecipes()
    }
    public func changeRevers() {
        isRevers.toggle()
    }
    public func updateSearchText(newText: String) {
        self.searchText = newText
    }
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return filteredData[indexParh.item]
    }
     func getingRecipes() {
        guard let searchText = searchText else { return }
        firebaseManager.getRecipesPageForPartialSearch(pageSize: pageSize, lastDocumentSnapshot: lastSnapshot, searchText: searchText) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result{
            case .success(let (recipes, _)):
                print("recipes::", recipes)
                strongSelf.filteredData = recipes
                strongSelf.dataSource = recipes.sorted  {
                    strongSelf.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
                    $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
                }
                if !strongSelf.filteredData.contains(strongSelf.dataSource) {
                    strongSelf.filteredData = strongSelf.dataSource

                } else {
                    strongSelf.isLastRecipe = true
                }
                strongSelf.delegate?.reloadCollectionView()
            case .failure(let error):
                // Handle the error appropriately
                print("Error fetching recipes: \(error)")
            }
        }


    }
    
   
}
