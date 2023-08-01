//
//  ProfileViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation
import UIKit
import Firebase

protocol ProfileViewControllerViewModelDelegate: AnyObject {
    func updateRecipes()
    func updateUsername()
}

final class ProfileViewControllerViewModel {
    //MARK: - Parameters
    weak var delegate: ProfileViewControllerViewModelDelegate?
    public var isLastRecipeOfCurrentuser: Bool = false {
        didSet {
            print("isLastRecipeOfCurrentuser",isLastRecipeOfCurrentuser)
        }
    }
    public var isLastRecipeOfFollowers: Bool = false{
        didSet {
            print("isLastRecipeOfFollowers",isLastRecipeOfFollowers)
        }
    }

    private var pageSize: Int = 4
     var lastSnapshot: DocumentSnapshot?
    let title = "Profile"
    let firebaseManager = FirebaseManager.shared
    let firebaseImageManager = FirebaseImageManager.shared
    var imageUrl: String? {
        didSet {
            guard let imageUrl = imageUrl else { return }
            uploadImageUrl(url: imageUrl)
        }
    }
    var isEdit = true
    public var recipes: [Recipe] = []
    public var username: String {
        guard let user = user else { return "no user" }
        return user.username
    }
    public var imageUrlString: String {
        guard let user = user else { return "no user" }
        return user.urlString ?? ""
    }
    public var followersCount: Int {
        return followers.count
    }
    private var user: GUser? = nil
    private var recipesFromFollowers: [Recipe] = [] 
    private var followers: [GUser] = []
    private var following: [GUser] = []
    //MARK: - Init
    init() {
        configure()
    }
    //MARK: - Functions
    public func updateName(_ newName: String) {
        // Update the name with the new value
        // You can add your logic here
        firebaseManager.updateUsername(newUsername: newName, username: username) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.delegate?.updateUsername()
            NotificationCenter.default.post(name: .updateUsername, object: nil, userInfo: nil)

        }
    }
    public func changeEdit() {
        isEdit.toggle()
    }
    public func signOut() {
        firebaseManager.signOut()
    }
     public func configure() {
         fetchCurrentUserRecipe()
         fetchAllFollowers()
         fetchAllFollowing()
    }
    public func getRecipe(indexPath: IndexPath) -> Recipe {
        return self.recipes[indexPath.item]
    }
    
    public func fetchCurrentUserRecipe() {
//       recipes = []
        firebaseManager.fetchCurrentUser(completion: { [ weak self ] user in
            guard let strongSelf = self else { return }
            guard let user = user else { return }
            strongSelf.user = user

                        strongSelf.firebaseManager.getRecipesPageForUser(pageSize: strongSelf.pageSize, lastDocumentSnapshot: strongSelf.lastSnapshot, username: user.username) { result in
                            switch result {
                                
                            case .success((let (recipes, nextSnapshot))):
                                print("Recipes count: ", recipes)
                                strongSelf.lastSnapshot = nextSnapshot
                                if !strongSelf.recipes.contains(recipes) {
                                strongSelf.recipes.append(contentsOf: recipes)
                              
                                    strongSelf.delegate?.updateRecipes()
            
                                } else {
                                    strongSelf.isLastRecipeOfCurrentuser = true
                                }
                                
                            case .failure(let error):
                                print("Error fetching recipes in ProfileViewControllerViewModel: \(error)")                }
                        }

                    })
        if recipes.count == 0 {
            delegate?.updateRecipes()
        }
            }
    public func getRecipeFromFollowers() {
              let users = followers.map{ user -> String in
                  print("users", user.username)
                  return user.username
              }
        firebaseManager.getRecipesPageForUsersAndUser(pageSize: pageSize, lastDocumentSnapshot: lastSnapshot, usernames: users, additionalUsername: nil) { result in
            switch result {
            case .success(let (recipes, nextSnapshot)):
                self.lastSnapshot = nextSnapshot
                if !self.recipes.contains(recipes) {
                self.recipes.append(contentsOf: recipes)
            }
                else {
                    self.isLastRecipeOfFollowers = true
                }
                self.delegate?.updateRecipes()

            case .failure(let error):
                print("Error fetching recipes in ProfileViewControllerViewModel: \(error)")
            }

          }

      }
    public func fetchAllFollowing() {
        firebaseManager.fetchCurrentUser { [weak self] currentUser in
            guard let currentUser = currentUser else { return }
            self?.firebaseManager.getAllFollowing(username: currentUser.username, completion: { [weak self] result in
                switch result {
                case .success(let users):
                    self?.following = users
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            self?.fetchAllFollowers()
        }

    }
    public func fetchAllFollowers() {
     
        firebaseManager.fetchCurrentUser { [weak self] currentUser in
            guard let currentUser = currentUser else { return }
            var currentFolloews: [GUser] = []
            self?.firebaseManager.getAllFollowersForUser(username: currentUser.username, completion: { [weak self] result in
                switch result {
                case .success(let users):
                    currentFolloews  = users
                    self?.followers = currentFolloews
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }

    }
 
 

    public func setImage(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = user else { return }
     
        firebaseImageManager.uploadImage(image) { [weak self] result in
            guard let mutableSelf = self else { return }
            switch result {
            case .success(let url):
                mutableSelf.imageUrl = url.absoluteString
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        guard let urlString = user.urlString, let url = URL(string: urlString) else { return }
        firebaseImageManager.deleteImage(at: url) { result in
            switch result {
            case .success():
                print("Successfuly delated image")
            case .failure(let error):
                print("Error with delete", error.localizedDescription)
            }
        }
    }
    private func uploadImageUrl(url: String) {
        guard let imageUrlString = imageUrl else { return }
        firebaseManager.getCurrentUsername { result in
            switch result {
                
            case .success(let username):
                self.firebaseManager.updateImageUrlForUser(username: username, urlString: imageUrlString) { error in
                    guard let error = error else {
                        NotificationCenter.default.post(name: .reloadMainViewControlelr, object: nil, userInfo: nil)
                        return }
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
