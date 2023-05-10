//
//  AuthViewType.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import Foundation


enum AuthViewType {
    case name, email, password
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .email:
            return "Email"
        case .password:
            return "Password"
        }
    }
    var isSecurityText: Bool {
        switch self {
        case .name:
            return false
        case .email:
            return false
        case .password:
            return true
        }
    }
    var placeholder: String {
        switch self {
        case .name:
            return "Enter your name"
        case .email:
            return "Enter your email"

        case .password:
            return "Enter your password"

        }
    }
    //TODO: - //    var textProperties:

}
