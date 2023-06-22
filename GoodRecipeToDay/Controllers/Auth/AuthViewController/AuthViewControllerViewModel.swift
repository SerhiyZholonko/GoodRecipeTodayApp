//
//  AuthViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 21.06.2023.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase


protocol AuthViewControllerViewModelDelegate: AnyObject {
    func isDismissVC(isAuth: Bool)
}
final class AuthViewControllerViewModel {
    weak var delegate: AuthViewControllerViewModelDelegate?
    
    private let firebaseManager = FirebaseManager.shared
    public func signIn(vc: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [unowned self] result, error in
          guard error == nil else {
            // ...
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            // Use the Google credential to sign in to Firebase
            Auth.auth().signIn(with: credential) {[weak self] authResult, error in
                if let error = error {
                    // Handle Firebase authentication error
                    print("Firebase authentication error: \(error.localizedDescription)")
                    return
                } else {
                    guard let authResult = authResult, let email = authResult.user.email, let name =  authResult.user.displayName else { return }
                    self?.firebaseManager.signUpInGoogle(username: name, email: email, uid: authResult.user.uid) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        self?.delegate?.isDismissVC(isAuth: true)
                    }
                }

                // User successfully signed in with Google and Firebase
                // Perform any necessary actions or navigate to the next screen
            }
          // ...
        }

    }
}

