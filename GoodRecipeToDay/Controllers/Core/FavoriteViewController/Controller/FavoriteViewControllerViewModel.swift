//
//  FavoriteViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation

protocol FavoriteViewControllerViewModelDelegate: AnyObject {
    func reloadCollectionView()
}


final class FavoriteViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: FavoriteViewControllerViewModelDelegate?
    let coredataManager = CoreDataManager.shared
    let firebaseManager = FirebaseManager.shared
    let titleFaworiteRecipes = "here are the best recipes"
    let titleFolowers = "followers"
    var recipes: [CDRecipe] = [] {
        didSet {
            print(recipes.count)
        }
    }
    var username: String?
    //MARK: - Init
    init() {
        
        configure()
       
    }
    //MARK: - Functions

    public func configure() {
    recipes = []
        firebaseManager.getCurrentUsername { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
                
            case .success(let username):
                guard let recipes = strongSelf.coredataManager.fetchData(entityName: "CDRecipe") as? [CDRecipe] else { return }
                
                for recipe in recipes  {
                    if recipe.username == username {
                        strongSelf.recipes.append(recipe)
                    }
                }
                strongSelf.delegate?.reloadCollectionView()
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    public func delete(indexPath: IndexPath) {
        
            // Remove the corresponding data object from your data source
            // For example, if you have an array called `favorites`, you can remove the item at the current index:
        coredataManager.delete(recipes[indexPath.item])
        recipes.remove(at: indexPath.item)
        delegate?.reloadCollectionView()

        
    }

}
