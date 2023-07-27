//
//  SenderViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 07.07.2023.
//

import Foundation

protocol SenderViewControllerViewModelDelegate: AnyObject {
    func updateVM(viewModel: SenderViewControllerViewModel)
}
final class SenderViewControllerViewModel {
    
    //MARK: - Properties
    
    weak var delegate: SenderViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    public let title = "Messages"
    public var users: [String] = []

    //MARK: - Init
    init() {
        getUsers()
    }
    //MARK: - Functions

    
    private func getUsers() {
                guard let currentUser = firebaseManager.mainUser else { return }

        firebaseManager.getAllUsernamesMessages(currentUser: currentUser.username) { [weak self] users, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let users = users, let strorgSelf = self else { return }
            strorgSelf.users = users
            strorgSelf.delegate?.updateVM(viewModel: strorgSelf)
        }
    }
}
