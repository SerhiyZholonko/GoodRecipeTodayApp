//
//  GoogleSignInManager.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.06.2023.
//

//import Foundation
//import Firebase
//import GoogleSignIn
//
//
//class GoogleSignInManager: NSObject {
//    static let shared = GoogleSignInManager()
//
//    private override init() {
//        super.init()
//
//        // Set up Google Sign-In
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if let error = error {
//                print("Google Sign-In error: \(error.localizedDescription)")
//                return
//            }
//
//            if let user = user {
//                // User is already signed in
//                // You can handle the success case here and perform any necessary actions
//                return
//            }
//
//            // Register with Google
//            let presentingViewController = AuthViewController()
//            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
//        }
//
//        // Set the delegate
//        GIDSignIn.sharedInstance.delegate = self
//    }
//}
//
//// Implement GIDSignInDelegate methods
//extension GoogleSignInManager: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print("Google Sign-In error: \(error.localizedDescription)")
//            return
//        }
//
//        guard let authentication = user.authentication else {
//            print("Unable to retrieve authentication from Google user.")
//            return
//        }
//
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//
//        // Register the user with Firebase using the Google credential
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print("Firebase authentication error: \(error.localizedDescription)")
//                return
//            }
//
//            // User is successfully registered and signed in with Google
//            // You can handle the success case here and perform any necessary actions
//        }
//    }
//}

