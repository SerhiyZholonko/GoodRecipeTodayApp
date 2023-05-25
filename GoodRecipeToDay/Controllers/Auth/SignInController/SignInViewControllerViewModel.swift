//
//  SignInViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.05.2023.
//

import Foundation

protocol SignInViewControllerViewModelDelegate: AnyObject {
    func forAlertError(error: Error)
}

final class SignInViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: SignInViewControllerViewModelDelegate?
    public var username: String = ""
    public var password: String = ""
    let firebaseManager = FirebaseManager.shared
    //MARK: - Functions
    public func signIn(completion: @escaping (Bool) -> Void) {
        firebaseManager.signIn(username: username, password: password) { [weak self]  error in
            switch error {
            case .none:
                completion(true)
            case .some(let error):
                completion(false)
                self?.delegate?.forAlertError(error: error)
            }
        }
    }
}
