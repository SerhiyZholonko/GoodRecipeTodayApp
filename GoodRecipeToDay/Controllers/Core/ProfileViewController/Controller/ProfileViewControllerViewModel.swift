//
//  ProfileViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation
import UIKit

protocol ProfileViewControllerViewModelDelegate: AnyObject {
    func updateRecipes()
}

final class ProfileViewControllerViewModel {
    //MARK: - Parameters
    weak var delegate: ProfileViewControllerViewModelDelegate?
    
    let title = "Profile"
    let firebaseManager = FirebaseManager.shared
    let firebaseImageManager = FirebaseImageManager.shared
    var imageUrl: String? {
        didSet {
            guard let imageUrl = imageUrl else { return }
            uploadImageUrl(url: imageUrl)
        }
    }
    public var recipes: [Recipe] = [] {
        didSet {
            delegate?.updateRecipes()
        }
    }
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
        firebaseManager.fetchCurrentUser(completion: { [ weak self ] user in
            guard let user = user else { return }
            self?.user = user
            self?.firebaseManager.getAllRecipesForUser(username: user.username) { result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }

        })
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
 
    public func getRecipeFromFollowers() {
          recipes = [] // Clear the recipes array before adding new recipes
          
          for user in followers {
              self.firebaseManager.getAllRecipesForUser(username: user.username) { result in
                  switch result {
                  case .success(let recipes):
                      self.recipes.append(contentsOf: recipes)
                  case .failure(let error):
                      print(error)
                  }
              }

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
