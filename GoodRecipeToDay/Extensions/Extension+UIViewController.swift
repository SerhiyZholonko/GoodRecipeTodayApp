//
//  Extension+UIViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.05.2023.
//

import UIKit

import UIKit

extension UIViewController {

    
    func presentAlertViewController(error massage: String) {
        DispatchQueue.main.async {
            let alertVC = AuthAlertViewController(viewModel: .init(massageText: massage))
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

}


