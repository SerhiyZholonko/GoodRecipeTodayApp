//
//  SearchViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    let viewModel = SearchViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBasicUI()
        
    }
    
    private func setupBasicUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .cyan
    }

}
