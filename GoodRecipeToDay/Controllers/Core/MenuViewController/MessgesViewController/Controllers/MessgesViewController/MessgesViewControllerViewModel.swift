//
//  MessgesViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.07.2023.
//

import Foundation


protocol MessgesViewControllerViewModelDelegate: AnyObject {
    func updateVM(viewModel: MessgesViewControllerViewModel)
}

final class MessgesViewControllerViewModel {
    
    weak var delegate: MessgesViewControllerViewModelDelegate?
    
    let firebaseManager = FirebaseManager.shared

    
    let title = "Messages"
    

    
    var messages: [Chat] = [] {
        didSet {
            print("TEST@@:", messages.count)
        }
    }
    private lazy var currentUser: GUser? = firebaseManager.mainUser
    private let username: String
    init(for username: String) {
        self.username = username
        getMessage()
    }
    
    public func saveMessage(message: String) {
        guard let currentUser = currentUser else { return }
        firebaseManager.updateMessageForUser(username: username, currentUsername: currentUser.username, sender: currentUser.username, chatMessage: message) {[weak self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Succussfully, saved message")
                self?.getMessage()
            }
        }
        firebaseManager.updateMessageForUser(username: currentUser.username, currentUsername: username, sender: currentUser.username, chatMessage: message) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Succussfully, saved message")
            }
        }
    }
    
    func getMessage() {
        guard let currentUser = firebaseManager.mainUser else { return }
        
        firebaseManager.getMessageForUser(currentUser: currentUser.username, for: username) { [weak self] messages, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let messages = messages else { return }
            strongSelf.messages = messages
            strongSelf.delegate?.updateVM(viewModel: strongSelf)
        }
    }
}



