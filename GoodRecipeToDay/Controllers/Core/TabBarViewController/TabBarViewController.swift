//
//  TabBarViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit
import FirebaseAuth



class TabBarViewController: RecipeTabBar {
    //MARK: - Properties
    let firebaseManager = FirebaseManager.shared
    let viewModel = TabBarViewControllerViewModel()
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        if let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)) {
            button.setImage(plusImage, for: .normal)
        }
        button.tintColor = .systemGray
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let mainViewController = UINavigationController(rootViewController: MainViewController())
    let searchViewController =  UINavigationController(rootViewController: SearchViewController())
    let addViewController = AddViewController()
    let favoriteController = UINavigationController(rootViewController: FavoriteViewController())
    var profileViewController = UINavigationController(rootViewController: ProfileViewController())
    
    //MARK: - Lovecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowAuthController()
        profileViewController = UINavigationController(rootViewController: ProfileViewController())
        viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteController.viewDidLoad()
        FirebaseManager.shared.getAllUsers { users, error in
            guard let users = users else { return }
            for user in users {
                print(user.uid)
            }
        }
        setupObserver()
        view.addSubview(addButton)
        setControllers()
        viewControllers = [
            mainViewController,
            searchViewController ,
            addViewController,
            favoriteController,
            profileViewController
        ]
        addConstraints()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Functions
    private func setControllers() {
        mainViewController.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        addViewController.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus"), tag: 3)
        favoriteController.tabBarItem = UITabBarItem(title: "favorite", image: UIImage(systemName: "bookmark"), tag: 4)
        profileViewController.tabBarItem = UITabBarItem(title: "profile", image: UIImage(systemName: "person"), tag: 5)
        tabBar.tintColor = UIColor.systemGreen
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundColor = .systemBackground
    }
    private func addConstraints() {
        let addButtonConstraints = [
            addButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 60),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(addButtonConstraints)
    }
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSignUp), name: .signUp, object: nil)
    }
    private func isShowAuthController() {

        if viewModel.isAuth() {
            let vc = AuthViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    @objc private func didTapAdd() {
        let addViewController = AddViewController()
        addViewController.modalTransitionStyle = .coverVertical
        addViewController.modalPresentationStyle = .fullScreen
        self.present(addViewController, animated: true)
    }
    @objc func didSignUp(){
        isShowAuthController()
        
    }
}


//MARK: - AuthViewControllerDelegate

extension TabBarViewController: AuthViewControllerDelegate {
    func didSuccess(isAuth: Bool) {
        if isAuth {
            
            dismiss(animated: true)
        }
    }
    
    
}
