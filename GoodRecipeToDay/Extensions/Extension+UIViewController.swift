//
//  Extension+UIViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.05.2023.
//

import UIKit

import JGProgressHUD

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
    
     func showErrorHUD(_ message: String) {
           if let mainWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let mainWindow = mainWindowScene.windows.first(where: { $0.isKeyWindow }) {
               let hud = JGProgressHUD(style: .extraLight)
               hud.indicatorView = JGProgressHUDErrorIndicatorView()
               hud.textLabel.text = message
               hud.show(in: mainWindow)
               hud.dismiss(afterDelay: 3.0, animated: true) // Auto-dismiss after 3 seconds
           }
       }
}


