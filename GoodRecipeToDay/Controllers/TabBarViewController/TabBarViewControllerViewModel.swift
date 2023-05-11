//
//  TabBarViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.05.2023.
//

import Foundation


final class TabBarViewControllerViewModel {
    let firebaseManager = FirebaseManager.shared
    
    
    func isAuth() -> Bool {
        return  firebaseManager.currentUser() == nil
    }
}
