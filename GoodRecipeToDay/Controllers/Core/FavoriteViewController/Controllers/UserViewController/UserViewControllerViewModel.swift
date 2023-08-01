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
    
    public var type: UserViewControllerType
    
    public var title: String {
        return "User"
    }
    
    public var follower: GUser {
        return user
    }
    public var recipes: [Recipe] = []
    private let user: GUser
    private lazy var currentUser: GUser? = firebaseManager.mainUser
    //MARK: - Init
    init(user: GUser, type: UserViewControllerType = .main) {
        self.user = user
        self.type = type
        configure()
    }
    //MARK: - Functions
    public func getRecipe(indexPath: IndexPath) -> Recipe {
        return self.recipes[indexPath.item]
    }
    public func saveMessage(message: String) {
        guard let currentUser = currentUser else { return }
        firebaseManager.updateMessageForUser(username: user.username, currentUsername: currentUser.username, sender: currentUser.username, chatMessage: message) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Succussfully, saved message")
            }
        }
        firebaseManager.updateMessageForUser(username: currentUser.username, currentUsername: user.username, sender: currentUser.username, chatMessage: message) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Succussfully, saved message")
            }
        }
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
