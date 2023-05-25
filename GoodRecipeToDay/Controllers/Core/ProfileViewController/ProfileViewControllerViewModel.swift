//
//  ProfileViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation

struct ProfileViewControllerViewModel {
    let title = "Profile"
    let firebaseManager = FirebaseManager.shared
    public func signOut() {
        firebaseManager.signOut()
            NotificationCenter.default.post(name: .signUp, object: nil, userInfo: nil)
    }
}
