//
//  MainViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import Foundation


protocol MainViewViewModelDelegate: AnyObject {
    func changeIsFollow(viewModel: MainViewViewModel)
}

final class MainViewViewModel {
    
    weak var delegate: MainViewViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    ///MARK: - Pulic

    public var isFallow: Bool = false {
        didSet {
            delegate?.changeIsFollow(viewModel: self)
        }
    }
    public lazy var mainImage: URL? = {
        return URL(string: self.recipe.mainImage)
    }()
    public var title: String {
        return recipe.title
    }
    public var description: String {
        return recipe.description
    }
    public var ingredients: [Ingredient] {
        return recipe.ingredients
    }
    public var instruction: [Step] {
        return recipe.steps
    }
    public var fromUser: String {
        return "by \(recipe.username)"
    }
    public var username: String {
        return recipe.username
    }
    public var time: String {
        return recipe.time
    }
    public var rate: Double {
       let bigRate = recipe.rate ?? 0.0
        if recipe.rateCounter != 0  {
            let newRate = bigRate / Double(recipe.rateCounter)
            return newRate
        } else  {
            return 0
        }
    }
    private var guser: GUser?

    //MARK: - Private
    private var recipeIdForUser: String?
    
    private let recipe: Recipe
    //MARK: - init
    init(recipe: Recipe) {
        self.recipe = recipe
        checkIsFavoriteStatus()
        getUser()
    }
    //MARK: - Functions
    private func getUser() {
        print(recipe.username)
        firebaseManager.getAllUsers {[weak self] users, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let users = users {
                for user in users {
                    if user.username == self?.recipe.username {
                        self?.guser = user
                        return
                    }
                }
            }
        }
    }
    public func userToFollower() {
        guard let user = self.guser else { return }
      
        firebaseManager.addFollowToUser(user) {[weak self] result in
            switch result {
                
            case .success():
                print("Successfully saved user!")
                self?.isFallow = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        firebaseManager.addFollowingToUser(user) {[weak self] result in
            switch result {
                
            case .success():
                print("Successfully add to following !")
                self?.isFallow = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    public func updateRecipeRate(rate: Double) {
        
        updateRecipeForUser(newRate: rate)
    }
 
    public func getIngredient(indexPath: IndexPath) -> Ingredient {
        return ingredients[indexPath.row]
    }
    public func getInstruction(indexPath: IndexPath) -> Step {
        return instruction[indexPath.row]
    }
    public func checkIsFavoriteStatus() {
        firebaseManager.fetchCurrentUser { currentUser in
            guard let currentUser = currentUser else { return }
            self.firebaseManager.getAllFollowersForUser(username: currentUser.username) { result in
                switch result {
                case .success(let users):
                    for user in users {
                        if user.username == self.recipe.username {
                            self.isFallow = true
                            return
                        }
                    }
                    self.isFallow = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func deleteFollowersFrolUser() {
        firebaseManager.fetchCurrentUser { currentUser in
            guard let currentUser = currentUser else { return }
            self.firebaseManager.getAllFollowersForUser(username: currentUser.username) { [ weak self ] result in
                switch result {
                case .success(let users):
                    for user in users {
                        if user.username == self?.recipe.username {
                            self?.firebaseManager.deleteFollower(user, completion: { result in
                                switch result {

                                case .success():
                                    print("Follower deleted")
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            })
                           
                           
                        }
                    }
                    guard let strongSelf = self else { return }
                    strongSelf.firebaseManager.getMainUserFromUsername(username: strongSelf.recipe.username) { result in
                        switch result {
                            
                        case .success(let user):
                            strongSelf.firebaseManager.deleteFollowing(user) { result in
                                switch result {
                                case .success():
                                    print("Following deleted")
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    self?.isFallow = false
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
           
        }
    }
    public func didPressedFollowBurron() {
        firebaseManager.fetchCurrentUser { currentUser in
            guard let currentUser = currentUser else { return }
            self.firebaseManager.getAllFollowersForUser(username: currentUser.username) { [ weak self ] result in
                switch result {
                    
                case .success(let users):
              
                    for user in users {
                        self?.firebaseManager.addFollowingToUser(user, completion: { result in
                            switch result {
                            case .success():
                                print("User added to following")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                        self?.firebaseManager.addFollowToUser(user) { result in
                            switch result {
                            case .success():
                                print("User added")
                                self?.isFallow = true
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }

                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    //MARK: - Private functions
     func getRecipeIDForUser() {
        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) {[weak self] result in
            switch result {
            case .success(let id):
                self?.recipeIdForUser = id
            case .failure(let error):
                print(error)
            }
        }
    }
    private func updateRecipeForUser(newRate: Double) {
        getRecipeIDForUser()

        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) {[weak self] result in
            switch result {
            case .success(let id):
                guard let strongSelf = self else { return }
                strongSelf.firebaseManager.updateRecipeForUser(username: strongSelf.recipe.username, recipeID: id, newRate: newRate, recipe: strongSelf.recipe) { error in
                    if let error = error {
                           print("Failed to update recipe rate: \(error)")
                       } else {
                           print("Recipe rate updated successfully.")
                       }
                }
            case .failure(let error):
                print(error)
            }
        }
        firebaseManager.getRecipeIDForUserMain(recipeName: recipe.title) {[weak self] result in
            switch result {
                
            case .success(let id):
                guard let strongSelf = self else { return }
                strongSelf.firebaseManager.updateRecipeMain(recipeID: id, newRate: newRate, recipe: strongSelf.recipe) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
     
    }
    
}
