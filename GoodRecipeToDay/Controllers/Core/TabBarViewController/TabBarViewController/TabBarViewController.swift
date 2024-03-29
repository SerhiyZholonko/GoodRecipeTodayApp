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
    
    let launchScreenView: LaunchScreenView = {
      let view = LaunchScreenView()
        view.isHidden = false
        return view
    }()
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        if let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)) {
            button.setImage(plusImage, for: .normal)
        }
        button.tintColor = .systemGray
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouched), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false // Disable tint adjustment

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var mainViewController = ContentViewController()
    let searchViewController =  UINavigationController(rootViewController: SearchViewController())
    let addViewController = AddViewController()
    var favoriteController = UINavigationController(rootViewController: FavoriteViewController())
    var profileViewController = UINavigationController(rootViewController: ProfileViewController())
    
    //MARK: - Lovecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteController = UINavigationController(rootViewController: FavoriteViewController())
        profileViewController = UINavigationController(rootViewController: ProfileViewController())
        viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteController.viewDidLoad()
        
        view.addSubview(addButton)
        setControllers()
        viewControllers = [
            mainViewController,
            searchViewController ,
            addViewController,
            favoriteController,
            profileViewController
        ]
        view.addSubview(launchScreenView)

        addConstraints()
        animateLaunchScreen()
      
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 

    //MARK: Functions
    private func setControllers() {
        mainViewController.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        addViewController.tabBarItem = DisabledTabBarItem(title: nil, image: nil, tag: 3)
        favoriteController.tabBarItem = UITabBarItem(title: "favorite", image: UIImage(systemName: "bookmark"), tag: 4)
        profileViewController.tabBarItem = UITabBarItem(title: "profile", image: UIImage(systemName: "person"), tag: 5)
        tabBar.tintColor = UIColor.systemGreen

    }
    private func addConstraints() {
        let addButtonConstraints = [
            addButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 30),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(addButtonConstraints)
        let launchScreenViewConstraints = [
            launchScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            launchScreenView.rightAnchor.constraint(equalTo: view.rightAnchor),
            launchScreenView.leftAnchor.constraint(equalTo: view.leftAnchor),
            launchScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(launchScreenViewConstraints)

    }
    private func animateLaunchScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.launchScreenView.isHidden = true
        }
    }
    @objc private func didTapAdd() {
        let addViewController = AddViewController()
        addViewController.modalTransitionStyle = .coverVertical
        addViewController.modalPresentationStyle = .fullScreen
        self.present(addViewController, animated: true)
    }

    
    // behavioer for button
    @objc func buttonTouched() {
        UIView.animate(withDuration: 0.4) {
            self.addButton.tintColor = UIColor.green // Set the desired tint color when the button is touched
        }
    }

    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.4) {
            self.addButton.tintColor = UIColor.clear // Set the normal tint color when the button is released
        }
        self.addButton.tintColor = UIColor.systemGray // Set the normal tint color when the button is released

    }
}


//MARK: - AuthViewControllerDelegate






