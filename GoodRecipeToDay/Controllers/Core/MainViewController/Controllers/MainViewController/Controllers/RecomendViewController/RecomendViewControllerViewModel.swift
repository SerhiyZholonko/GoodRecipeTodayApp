//
//  RecomendViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import Foundation
import FirebaseFirestore


protocol RecomendViewControllerViewModelDelegate: AnyObject {

    func didFetchData()
    func didFail(with error: Error)
}

final class RecomendViewControllerViewModel {
    //MARK: - Properties
     weak var delegate: RecomendViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    let title = "Redomend"
    
    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false
    
    private(set) var dataSource: [Recipe] = []

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
                let newRecipes = recipes.sorted { recipe1, recipe2 in
                    let rate1 = recipe1.rate ?? 0.0
                    let rate2 = recipe2.rate ?? 0.0
                    let counter1 = recipe1.rateCounter
                    let counter2 = recipe2.rateCounter

                    let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                    let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)

                    return value1 > value2
                }

                self.dataSource = newRecipes
                self.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }

}
