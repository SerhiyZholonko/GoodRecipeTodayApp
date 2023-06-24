//
//  PhotoInfoViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.06.2023.
//

import Foundation

protocol PhotoInfoViewViewModelDelegate: AnyObject {
    func updateUser(viewModel: PhotoInfoViewViewModel)
}

final class PhotoInfoViewViewModel {
    //MARK: - Properties
    weak var delegate: PhotoInfoViewViewModelDelegate?
 
    public var username: String {
        return user?.username ?? "no username"
    }
    public var email: String {
        return user?.email ?? "no emil"
    }
    public var stringUrl: String {
        return user?.urlString ?? "no urlString"
    }
    public var followersCount: Int {
        return followers.count
    }
    public var followingCount: Int {
        return following.count
    }
    public var recipesCount: Int {
        return recipes.count
    }
    private let firebaseManager = FirebaseManager.shared

    private var recipes: [Recipe] = []
    private var user: GUser?
    private var followers: [GUser] = []
    private var following: [GUser] = []
    //MARK: - Init
    init() {
     
        getUser()
    }

    //MARK: - Functions
    public func getUser() {
        firebaseManager.fetchCurrentUser {[weak self] user in
            guard let strongSelf = self else { return }
            strongSelf.user = user
            strongSelf.fetchAllFollowers()
            strongSelf.fetchAllFollowing()
            strongSelf.fetchCurrentUserRecipe()
        }
    }
    public func fetchCurrentUserRecipe() {
        firebaseManager.fetchCurrentUser(completion: { [ weak self ] user in
            guard let user = user else { return }
            self?.user = user
            self?.firebaseManager.getAllRecipesForUser(username: user.username) { result in
                guard let strongSelf = self else { return }

                switch result {
                case .success(let recipes):
                    strongSelf.recipes = recipes
                    strongSelf.delegate?.updateUser(viewModel: strongSelf)

                case .failure(let err):
                    print(err.localizedDescription)
                }
            }

        })
    }
    private func fetchAllFollowing() {
        firebaseManager.fetchCurrentUser { [weak self] currentUser in
            guard let currentUser = currentUser else { return }
            self?.firebaseManager.getAllFollowing(username: currentUser.username, completion: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let users):
                    strongSelf.following = users
                    strongSelf.delegate?.updateUser(viewModel: strongSelf)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })

        }

    }
    private func fetchAllFollowers() {
        firebaseManager.fetchCurrentUser { [weak self] currentUser in
            guard let currentUser = currentUser else { return }
            self?.firebaseManager.getAllFollowersForUser(username: currentUser.username, completion: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let users):
                    strongSelf.followers = users
                    strongSelf.delegate?.updateUser(viewModel: strongSelf)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })

        }

    }
}

