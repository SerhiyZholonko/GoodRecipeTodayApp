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
    var filteredData: [Recipe] = []

    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false
    private var isRevers: Bool = false {
        didSet {
            getingRecipes()
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
    func getingRecipes() {
        firebaseManager.getAllRecipes {[weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let recipes):
                strongSelf.dataSource = recipes.sorted  {
                    strongSelf.isRevers ? $0.createdAt ?? Timestamp(date: Date()) > $1.createdAt ?? Timestamp(date: Date()) :
                    $0.createdAt ?? Timestamp(date: Date()) < $1.createdAt ?? Timestamp(date: Date())
                }
                strongSelf.filteredData = strongSelf.dataSource
                strongSelf.delegate?.didFetchData()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
}
