//
//  ContentViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.07.2023.
//

import UIKit


enum MenuState {
    case opened
    case close
}

final class ContentViewController: UIViewController {
    
    private var menuState: MenuState = .opened
    //MARK: - Properties
    let menuVC = MenuViewController()
    let homeVC = MainViewController()
    var navVC: UINavigationController?
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChaildVC()
        homeVC.delegate = self
        setupGesture()
    }
    //MARK: - Functions
    private func setupGesture() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
               menuVC.view.addGestureRecognizer(swipeGesture)
    }
    private func addChaildVC() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
     
        guard let navView = navVC?.view else {
             return
         }
         let translation = gesture.translation(in: view)
         
         switch gesture.state {
         case .changed:
             let newX = navView.frame.origin.x + translation.x
             if newX >= 0 && newX <= homeVC.view.frame.size.width - 100 {
                 navView.frame.origin.x = newX
             }
             
             gesture.setTranslation(.zero, in: view)
             
         case .ended:
             let threshold: CGFloat = -50
             if navView.frame.origin.x < threshold {
                 closeMenu()
             } else {
                 openMenu()
             }
             
         default:
             break
         }
     }
     
     private func openMenu() {
         UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
             self.navVC?.view.frame.origin.x = -self.homeVC.view.frame.size.width + 100
         } completion: { [weak self] done in
             if done {
                 self?.menuState = .close
             }
         }
     }
     
     private func closeMenu() {
         UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
             self.navVC?.view.frame.origin.x = 0
         } completion: { [weak self] done in
             if done {
                 self?.menuState = .opened
             }
         }
     }
}


extension ContentViewController: MainViewControllerDelegate {
    func didTapMenuButton() {
        switch menuState {
        case .opened:
            self.openMenu()
        case .close:
            self.closeMenu()
        }
    }
}

