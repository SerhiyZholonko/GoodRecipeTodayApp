//
//  UserViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.07.2023.
//

import Foundation

protocol UserViewControllerViewModelDelegate: AnyObject {
    func updateRecipes()
}

final class UserViewControllerViewModel {
    //MARK: - Parameters
    let firebaseManager = FirebaseManager.shared

    weak var delegate: UserViewControllerViewModelDelegate?
    
    public var title: String {
        return "User"
    }
    
    public var follower: GUser {
        return user
    }
    public var recipes: [Recipe] = []
    private let user: GUser
    //MARK: - Init
    init(user: GUser) {
        self.user = user
        configure()
    }
    //MARK: - Functions
    public func getRecipe(indexPath: IndexPath) -> Recipe {
        return self.recipes[indexPath.item]
    }
    private func configure() {
        fetchCurrentUserRecipe()
        
   }
    private func fetchCurrentUserRecipe() {
           firebaseManager.getAllRecipesForUser(username: user.username) {[weak self] result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    self?.delegate?.updateRecipes()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }

        }
}
