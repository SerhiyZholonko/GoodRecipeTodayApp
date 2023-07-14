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
    
  
    func addChildViewController(_ childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }
    
    
}


