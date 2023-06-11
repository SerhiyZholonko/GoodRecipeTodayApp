//
//  UserViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import Foundation

protocol UserViewViewModelDelegate: AnyObject {
    func showButtonFollower(isShowButton: Bool)
}

final class UserViewViewModel {
    //MARK: - Properties
    weak var delegate: UserViewViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    private let username: String
    //MARK: - Init
    init(username: String) {
        self.username = username
        isShowFollowButton()
    }
    //MARK: - Functions
   
    public func isShowFollowButton(){
        firebaseManager.fetchCurrentUser {[weak self] user in
            guard let user = user else { return  }
            if self?.username == user.username {
                self?.delegate?.showButtonFollower(isShowButton: true)
            } else {
                self?.delegate?.showButtonFollower(isShowButton: false)
                
            }
        }
    }
}
