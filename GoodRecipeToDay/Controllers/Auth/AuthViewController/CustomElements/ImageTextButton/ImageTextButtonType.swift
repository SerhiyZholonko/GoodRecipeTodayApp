//
//  ImageTextButtonType.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.05.2023.
//

import UIKit

enum ImageTextButtonType {
    case email
    case google
    case facebook
    var title: String {
        switch self {
        case .email:
            return "Sign up with email"
        case .google:
            return "Sign Up with google"
        case .facebook:
            return "Sign Up with facebook"
        }
    }
    var image: UIImage? {
        switch self {
            
        case .email:
            return UIImage(systemName: "envelope")
        case .google:
            return UIImage(named: "google")
        case .facebook:
            return UIImage(named: "facebook")

        }
    }
}
