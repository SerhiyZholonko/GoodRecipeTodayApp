//
//  RecipesOfTheWeekControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import Foundation
import Firebase


protocol RecipesOfTheWeekControllerViewModelDelegate: AnyObject {
    func didFetchData()
    func didFail(with error: Error)
}

final class RecipesOfTheWeekControllerViewModel {
    //MARK: - Properties
    weak var delegate: RecipesOfTheWeekControllerViewModelDelegate?
    let title = "The Week"
    let firebaseManager = FirebaseManager.shared
    public var dataSource: [Recipe] = []
    public var isLastRecipe: Bool = false
    var filteredData: [Recipe] = []

    private var pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var lastRecipe: Recipe?
    private var isFetchingData: Bool = false
    private var isRevers: Bool = false {
               didSet {
                   reverce()
                   delegate?.didFetchData()
               }
           }

   
    //MARK: - Init
    init() {
        getingRecipes()
    }
    //MARK: - Functions
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return filteredData[indexParh.item]
    }
    public func changeRevers() {
        isRevers.toggle()
    }
    public func getRecipesCount() -> Int {
        return dataSource.count
    }
    private func reverce() {
        filteredData = filteredData.sorted  {
            self.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
            $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
        }
    }
    func getingRecipes() {
        firebaseManager.getAllPaginationRecipes(pageSize: pageSize, lastRecipe: lastSnapshot) { result in
            
            switch result {
            case .success(let (recipes, nextSnapshot)):
                self.lastSnapshot = nextSnapshot
                self.dataSource = recipes.sorted  {
                    self.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
                    $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
                }
                if !self.filteredData.contains(self.dataSource) {
                    self.filteredData.append(contentsOf: self.dataSource)
                } else {
                    self.isLastRecipe = true
                }
                    self.delegate?.didFetchData()
            case .failure(let error):
                // Handle the error appropriately
                print("Error fetching recipes: \(error)")
            }
        }

    }
}
