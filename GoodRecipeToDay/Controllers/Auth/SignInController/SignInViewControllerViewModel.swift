//
//  SignInViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.05.2023.
//

import Foundation
import JGProgressHUD

protocol SignInViewControllerViewModelDelegate: AnyObject {
    func forAlertError(error: Error)
}

final class SignInViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: SignInViewControllerViewModelDelegate?
    public var username: String = ""
    public var password: String = ""
    let firebaseManager = FirebaseManager.shared
    private let progressHUD = JGProgressHUD(style: .extraLight)
    
    //MARK: - Functions
    public var isUser: Bool {
        return !firebaseManager.isUser
    }
    public func signIn(completion: @escaping (Result<Void, Error>) -> Void) {
        // Perform validation on the username and password properties
        guard isValidUsername(username) else {
            completion(.failure(ValidationError.invalidUsername))
            return
        }
        
        guard isValidPassword(password) else {
            completion(.failure(ValidationError.invalidPassword))
            return
        }
        
        // If both username and password are valid, show the progress HUD
        if let mainWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                let mainWindow = mainWindowScene.windows.first(where: { $0.isKeyWindow }) {
                 // If both username and password are valid, show the progress HUD
                 progressHUD.textLabel.text = "Signing In..."
                 progressHUD.show(in: mainWindow)
             }
        
        // Call the Firebase sign-in method
        firebaseManager.signIn(username: username, password: password) { [weak self] result in
            // Hide the progress HUD after sign-in attempt
            self?.progressHUD.dismiss(animated: true)
            switch result {
                
            case .success():
                completion(.success(Void()))

            case .failure(let error):
                completion(.failure(error))
                self?.delegate?.forAlertError(error: error)
            }

        }
    }
    func validation() -> Bool {
        return isValidUsername(username) && isValidPassword(password)
    }
    // Validation functions for username and password
    private func isValidUsername(_ username: String) -> Bool {
        // Add your validation logic for the username here
        // For example, check for minimum length, disallowed characters, etc.
        // Return true if valid, false otherwise
        return username.count >= 2
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // Add your validation logic for the password here
        // For example, check for minimum length, required characters, etc.
        // Return true if valid, false otherwise
        return password.count >= 6
    }
    
    // Error enum for validation errors
  
}
enum ValidationError: Error {
    case invalidUsername
    case invalidPassword
}
