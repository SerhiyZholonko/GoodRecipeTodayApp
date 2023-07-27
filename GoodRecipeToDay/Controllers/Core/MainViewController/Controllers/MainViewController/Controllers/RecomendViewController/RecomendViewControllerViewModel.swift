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
    public var isLastRecipe: Bool = false
    private var isFetchingData: Bool = false
    private var isRevers: Bool = false {
        didSet {
            reverce()
            delegate?.didFetchData()
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
    private func reverce() {
        filteredData = filteredData.sorted { recipe1, recipe2 in
                            let rate1 = recipe1.rate ?? 0.0
                            let rate2 = recipe2.rate ?? 0.0
                            let counter1 = recipe1.rateCounter
                            let counter2 = recipe2.rateCounter
        
                            let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                            let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)
        
                            return self.isRevers ? value1 > value2 : value1 < value2
                        }
    }
    func getingRecipes() {
        
            firebaseManager.getAllPaginationRecipes(pageSize: pageSize, lastRecipe: lastSnapshot) { result in
                
                switch result {
                case .success(let (recipes, nextSnapshot)):
                    self.lastSnapshot = nextSnapshot

                    let newRecipes = recipes.sorted { recipe1, recipe2 in
                                        let rate1 = recipe1.rate ?? 0.0
                                        let rate2 = recipe2.rate ?? 0.0
                                        let counter1 = recipe1.rateCounter
                                        let counter2 = recipe2.rateCounter
                    
                                        let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                                        let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)
                    
                                        return self.isRevers ? value1 > value2 : value1 < value2
                                    }
                    
                    if !self.filteredData.contains(newRecipes) {
                        self.filteredData.append(contentsOf: newRecipes)
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
