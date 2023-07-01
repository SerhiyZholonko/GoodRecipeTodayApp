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
    private var isRevers: Bool = false {
        didSet {
            getingRecipes()
        }
    }
    var filteredData: [Recipe] = [] 

    var dataSource: [Recipe] = []

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
    func getingRecipes() {
        firebaseManager.getAllRecipes {[weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let recipes):
                let newRecipes = recipes.sorted { recipe1, recipe2 in
                    let rate1 = recipe1.rate ?? 0.0
                    let rate2 = recipe2.rate ?? 0.0
                    let counter1 = recipe1.rateCounter
                    let counter2 = recipe2.rateCounter

                    let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                    let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)

                    return strongSelf.isRevers ? value1 > value2 : value1 < value2
                }

                strongSelf.dataSource = newRecipes
                strongSelf.filteredData = strongSelf.dataSource
                strongSelf.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }

}
