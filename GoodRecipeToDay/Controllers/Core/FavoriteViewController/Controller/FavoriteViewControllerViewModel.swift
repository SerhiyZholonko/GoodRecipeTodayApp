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
    let title = "here are the best recipes"
     var recipes: [CDRecipe] = []
    //MARK: - Init
    init() {
        configure()
    }
    //MARK: - Functions
    public  func configure() {
        self.recipes = coredataManager.fetchData(entityName: "CDRecipe")
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
}
