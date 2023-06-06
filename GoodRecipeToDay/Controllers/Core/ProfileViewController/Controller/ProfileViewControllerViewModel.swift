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
    public var recipes: [Recipe] = []
    public var username: String {
        guard let user = user else { return "no user" }
        return user.username
    }
    public var imageUrlString: String {
        guard let user = user else { return "no user" }
        return user.urlString ?? ""
    }
    private var user: GUser? = nil 
    //MARK: - Init
    init() {
        configure()
    }
    //MARK: - Functions
    public func signOut() {
        firebaseManager.signOut()
            NotificationCenter.default.post(name: .signUp, object: nil, userInfo: nil)
    }
     public func configure() {
        fetchCurrentUserRecipe()
    }
    public func fetchCurrentUserRecipe() {
        firebaseManager.fetchCurrentUser(completion: { [ weak self ] user in
            guard let user = user else { return }
            print("Current user: ", user)
            self?.user = user
            self?.firebaseManager.getAllRecipesForUser(username: user.username) { result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    self?.delegate?.updateRecipes()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }

        })
    }
    public func fetchAllRecipe() {
        firebaseManager.getAllRecipes { [weak self] result in
            switch result {
            case .success(let recipes):
                let newRecipes = recipes.sorted { $0.rate ?? 0.0 < $1.rate ?? 0.0}
                self?.recipes = newRecipes
                self?.delegate?.updateRecipes()
            case .failure(let error):
                print(error)
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
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
