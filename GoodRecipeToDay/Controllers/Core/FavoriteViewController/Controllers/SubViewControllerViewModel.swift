//
//  SubViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import Foundation

protocol SubViewControllerViewModelDelegate: AnyObject {
    func updateViewModel(viewModel: SubViewControllerViewModel)
}
final class SubViewControllerViewModel {
    //MARK: - Properties
  
    weak var delegate: SubViewControllerViewModelDelegate?
    
    private let firebaseManager = FirebaseManager.shared
    var followers: [GUser] = [] 
    var user: GUser?
    //MARK: - Init
    init() {
        getAllFollowersForUser()
    }
    //MARK: - Functions
    public func getUser(indexPath: IndexPath) -> GUser{
       return self.followers[indexPath.item]
    }

   public  func getAllFollowersForUser() {
        firebaseManager.fetchCurrentUser { [weak self] user in
            guard let user = user else {
                print("No user")
                return
            }
             let username =  user.username
            self?.firebaseManager.getAllFollowersForUser(username: username) { [weak self] result in
                switch result {
                case .success(let followers):
                    self?.followers = followers
                    guard let strongSelf = self, let delegate = strongSelf.delegate else { return }
                    delegate.updateViewModel(viewModel: strongSelf)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
           
        }
   
    }
    private func getUsers() {
        firebaseManager.getAllUsers { [weak self] users, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else  {
                guard let users = users else { return }
                self?.followers = users
                
            }
            
        }
    }
    
}
