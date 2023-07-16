//
//  Extension+Notification.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.05.2023.
//

import Foundation

extension Notification.Name{
    static let signUp = Notification.Name("signUp")
    static let signIn = Notification.Name("signIn")

    static let authVCClose = Notification.Name("authVCClose")
    static let updateRecipes = Notification.Name("updateRecipes")
    static let updateUsername = Notification.Name("updateUsername")
    static let reloadMainViewControlelr = Notification.Name("reloadMainViewControlelr")
    static let reloadFavoriteController = Notification.Name("reloadFavoriteController")
    static let reloadSearchController = Notification.Name("reloadSearchController")
    static let reloadMainSearchController = Notification.Name("reloadMainSearchController")
    static let didUpdateCoredata = Notification.Name("didUpdateCoredata")


}
