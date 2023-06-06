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
    private let firebaseManager = FirebaseManager.shared

    
    private var user: GUser?
    
    //MARK: - Init
    init() {
        getUser()
    }

    //MARK: - Functions
    public func getUser() {
        firebaseManager.fetchCurrentUser { user in
            self.user = user
            self.delegate?.updateUser(viewModel: self)
        }
    }
}

