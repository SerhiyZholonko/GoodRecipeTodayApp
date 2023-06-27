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
    let title = "here are the best recipes"
     var recipes: [CDRecipe] = []
    var username: String?
    //MARK: - Init
    init() {
        configure()
        setUsername()
    }
    //MARK: - Functions
    public func configure() {
        guard let username = username else { return }
        guard let recipes = coredataManager.fetchData(entityName: "CDRecipe") as? [CDRecipe] else { return }
        for recipe in recipes  {
            if recipe.username == username {
                self.recipes.append(recipe)
            }
        }
        delegate?.reloadCollectionView()
    }

    
    public func delete(indexPath: IndexPath) {
        
            // Remove the corresponding data object from your data source
            // For example, if you have an array called `favorites`, you can remove the item at the current index:
        coredataManager.delete(recipes[indexPath.item])
        recipes.remove(at: indexPath.item)
            // Update the collection view
            delegate?.reloadCollectionView()
        
    }
    private func setUsername() {
        firebaseManager.fetchCurrentUser { [weak self] user in
            guard let username = user?.username else { return }
         self?.username = username
        }
    }
}
