//
//  FollowViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 31.07.2023.
//

import UIKit


class FollowViewViewModel {
 
    private let firebaseManager = FirebaseManager.shared
    private var currentUser: GUser? {
        didSet {
            guard let currentUser = currentUser else {return}
            currentUserObserver?(URL(string: currentUser.urlString ?? ""))
        }
    }
    private var followrUser: GUser? {
        didSet {
            followerUserObserver?(followrUser)
            guard let followrUser = followrUser else { return }
            followerUserUrlObserver?(URL(string: followrUser.urlString ?? ""))
        }
    }
    public var user: GUser?

    public var currentUserObserver: ((URL?) -> Void)?
    public var followerUserUrlObserver: ((URL?) -> Void)?
    public var followerUserObserver: ((GUser?) -> Void)?
    init(followerUsername: String) {
        getCurrentuser()
        getFollowerUser(username: followerUsername)
    }
    //MARK: - Functions
    private  func getCurrentuser() {
//        var currentUser = firebaseManager.curenUser()
        self.firebaseManager.fetchCurrentUser { [weak self] user in
            guard let user = user else { return }
            self?.currentUser = user
        }
    }
    private func getFollowerUser(username: String) {
        firebaseManager.getUserForUsername(username: username) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.followrUser = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
