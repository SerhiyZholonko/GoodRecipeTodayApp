//
//  SignUpViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import Foundation

protocol SignUpViewControllerViewModelDelegate: AnyObject {
    func forAlertError(error: Error)
}


final class SignUpViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: SignUpViewControllerViewModelDelegate?
    public var username: String = ""
    public var email: String = ""
    public var password: String = ""
    public var isAgree: Bool = false
    let firebaseManager = FirebaseManager.shared
    //MARK: - Functions
    public func signUp(completion: @escaping (Bool) -> Void) {
        firebaseManager.signUp(username: username, email: email, password: password) { [weak self]  error in
            switch error {
            case .none:
                print("Success")
                completion(true)
            case .some(let error):
                completion(false)
                self?.delegate?.forAlertError(error: error)
            }
        }
    }
    
}
