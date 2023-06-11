//
//  SubCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import UIKit

final class SubCollectionViewCellViewModel {
    //MARK: - Properties
    let firebaseManager = FirebaseManager.shared
    public var nameLabel: String {
        return name
    }
    public var urlInmage: URL? {
        guard let stringUrl = stringUrl else { return nil }
        return URL(string: stringUrl)
    }
    private let name: String
    private let stringUrl: String?
    private let user: GUser
    init(user: GUser) {
        self.user = user
        self.name = user.username
        self.stringUrl = user.urlString
    }
    
    //MARK: Functions
    
    public func deleteFollower () {
        print(user.username)
        firebaseManager.deleteFollower(user) { result in
            switch result {
                
            case .success():
                print("Deleted follower successfuly!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
