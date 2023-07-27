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
    public var isLastRecipe: Bool = false
    private let pageSize: Int = 8
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
    private var filteredRecipes: [Recipe] = []

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

         firebaseManager.getRecipesPageForCategory(pageSize: pageSize, lastDocumentSnapshot: lastSnapshot, category: category) { [weak self] result in
             guard let strongSelf = self else { return }
             switch result {
             case .success(let (recipes, nextSnapshot)):
                 strongSelf.lastSnapshot = nextSnapshot
                 if !strongSelf.dataSource.contains(recipes) {
                     strongSelf.dataSource.append(contentsOf: recipes)
                 } else {
                     strongSelf.isLastRecipe = true
                 }
                 strongSelf.filteredRecipes = strongSelf.dataSource.filter { $0.category == strongSelf.category.rawValue }

                 strongSelf.dataSource = strongSelf.filteredRecipes.sorted  {
                                   strongSelf.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
                                   $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
                               }
                 strongSelf.delegate?.didFetchData()
                 
             case .failure(let error):
                 print(error)
             }
         }
    }
}
