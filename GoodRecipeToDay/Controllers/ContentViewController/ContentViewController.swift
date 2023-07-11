//
//  ContentViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.07.2023.
//

import UIKit
import SDWebImage


enum MenuState {
    case opened
    case close
}

final class ContentViewController: UIViewController {
    
    private var viewModel = ContentViewControllerViewModel()
    
    private var menuState: MenuState = .opened
    //MARK: - Properties
    let homeVC = MainViewController()
    lazy var menuVC = MenuViewController()
    var navVC: UINavigationController?
    //MARK: - Init
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowAuthController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
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
        setupObserver()
        menuVC.didMove(toParent: self)
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
//        menuVC.delegate = self
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
            let gestureLocation = gesture.location(in: view)
            let swipeZoneWidth: CGFloat = 100 // Adjust the width of the right swipe zone as needed
            let swipeZoneStartX = homeVC.view.frame.size.width - swipeZoneWidth

            if gestureLocation.x > swipeZoneStartX && navView.frame.origin.x < threshold {
                closeMenu()
            } else {
                openMenu()
            }

        default:
            break
        }
    }
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSignUp), name: .signUp, object: nil)
    }
    private func isShowAuthController() {

        if viewModel.isAuth() {
            closeMenu()
            let vc = AuthViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    @objc func didSignUp(){
        isShowAuthController()
    }
     private func openMenu() {
         UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
             self.homeVC.darkView.isHidden = false
             self.navVC?.view.frame.origin.x = -self.homeVC.view.frame.size.width + 100
         } completion: { [weak self] done in
             if done {
                 self?.menuState = .close
             }
         }
     }
     
     private func closeMenu() {
         UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
             self.homeVC.darkView.isHidden = true
             self.navVC?.view.frame.origin.x = 0
         } completion: { [weak self] done in
             if done {
                 self?.menuState = .opened
             }
         }
     }
}


extension ContentViewController: MainViewControllerDelegate {
    func touchDisMiss() {
        closeMenu()
    }
    
    func updateImageInMenu() {
        DispatchQueue.main.async {
            self.menuVC.viewModel.getUser()
            self.menuVC.setupImageAndName()
        }
    }
    
    func didTapMenuButton() {
        switch menuState {
        case .opened:
            self.openMenu()
        case .close:
            self.closeMenu()
        }
    }
}

extension ContentViewController: AuthViewControllerDelegate {
    func didSuccess(isAuth: Bool) {
        if isAuth {
            
            dismiss(animated: true)
            menuVC = MenuViewController()
        }
    }
    
    
}






