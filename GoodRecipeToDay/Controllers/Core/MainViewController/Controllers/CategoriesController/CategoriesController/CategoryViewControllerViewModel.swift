//
//  CategoryViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 24.05.2023.
//

import Foundation
import FirebaseFirestore


protocol CategoryViewControllerViewModelDelegate: AnyObject {
    func didFetchData()
    func didFail(with error: Error)
}

final class CategoryViewControllerViewModel {
    //MARK: - Properties
    
    weak var delegate: CategoryViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    
    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false
    
    public var title: String {
        return category.title
    }
    private(set) var dataSource: [Recipe] = []

    private let category: Categories
    init(category: Categories) {
        self.category = category
        getingRecipes()
    }
    
    //MARK: - Functions
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return dataSource[indexParh.item]
    }
     func getingRecipes() {
        firebaseManager.getAllRecipes { result in
            switch result {
            case .success(let recipes):
                self.dataSource = recipes
                self.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
}
