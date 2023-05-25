//
//  ProfileViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    let viewModel = ProfileViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
    }

    private func setupBasicUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(didTappedSignOut))
    }
    
    //MARK: - Functions
    
    @objc private func didTappedSignOut() {
        viewModel.signOut()
        tabBarController?.selectedIndex = 0

    }

}



