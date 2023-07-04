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
    private var isRevers: Bool = false {
        didSet {
            getingRecipes()
        }
    }
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
    public func changeRevers() {
        isRevers.toggle()
    }
     func getingRecipes() {
        firebaseManager.getAllRecipes {[weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let recipes):
                let filteredRecipes = recipes.filter { $0.category == strongSelf.category.rawValue }

                strongSelf.dataSource = filteredRecipes.sorted  {
                    strongSelf.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
                    $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
                }
                strongSelf.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
}
