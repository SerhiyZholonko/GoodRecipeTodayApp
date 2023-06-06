//
//  SubViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import Foundation


final class SubViewControllerViewModel {
    //MARK: - Properties
  
    private let firebaseManager = FirebaseManager.shared
     var users: [GUser] = []
    //MARK: - Init
    init() {
        getUsers()
    }
    //MARK: - Functions
    public func getUser(indexPath: IndexPath) -> GUser{
       return self.users[indexPath.item]
    }
    
    private func getUsers() {
        firebaseManager.getAllUsers { [weak self] users, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else  {
                guard let users = users else { return }
                self?.users = users
            }
            
        }
    }
    
}
