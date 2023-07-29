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
    public func signUp(completion: @escaping (Bool, String?) -> Void) {
        // Perform basic validation
        guard !username.isEmpty else {
            completion(false, "Please enter a username.")
            return
        }
        
        guard !email.isEmpty else {
            completion(false, "Please enter an email address.")
            return
        }
        
        guard !password.isEmpty else {
            completion(false, "Please enter a password.")
            return
        }
        
        guard isAgree else {
            completion(false, "Please agree to the terms and conditions.")
            return
        }
        
        // If all validations pass, proceed with sign-up
        firebaseManager.signUp(username: username, email: email, password: password) { [weak self] error in
            if let error = error {
                completion(false, "Sign-up failed. \(error.localizedDescription)")
                self?.delegate?.forAlertError(error: error)
            } else {
                completion(true, "Sign-up successful!")
            }
        }
    }
    func validation() -> Bool {
        return isValidUsername(username) &&  isValidEmail(email) && isValidPassword(password) && isValidAgree(isAgree: isAgree)
    }
    // Validation functions for username and password
    private func isValidUsername(_ username: String) -> Bool {
        // Add your validation logic for the username here
        // For example, check for minimum length, disallowed characters, etc.
        // Return true if valid, false otherwise
     
        return username.count >= 3
    }
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    private func isValidPassword(_ password: String) -> Bool {
        
        // Add your validation logic for the password here
        // For example, check for minimum length, required characters, etc.
        // Return true if valid, false otherwise
        return password.count >= 6
    }
    private func isValidAgree(isAgree: Bool) -> Bool {
        return isAgree
    }
}

