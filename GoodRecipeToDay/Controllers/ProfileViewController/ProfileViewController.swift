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
        view.backgroundColor = .red
    }

  

}
