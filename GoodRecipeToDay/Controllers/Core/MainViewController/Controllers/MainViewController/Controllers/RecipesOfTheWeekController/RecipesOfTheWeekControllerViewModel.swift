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
    private(set) var dataSource: [Recipe] = []

    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false

    //MARK: - Init
    init() {
        getingRecipes()
    }
    //MARK: - Functions
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return dataSource[indexParh.item]
    }
    public func getRecipesCount() -> Int {
        return dataSource.count
    }
    func getingRecipes() {
        firebaseManager.getAllRecipes { result in
            switch result {
            case .success(let recipes):
                self.dataSource = recipes.sorted  {
                    $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date())
                }
                self.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
}
