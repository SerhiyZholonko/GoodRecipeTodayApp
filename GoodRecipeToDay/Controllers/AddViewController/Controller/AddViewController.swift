//
//  AddViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class AddViewController: UIViewController {
    //MARK: - Properties
    let viewModel = AddViewControllerViewModel()
    
    let topView = TopBarView()
    let bestImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray
        iv.image = UIImage(named: "food")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleRecipeTeactsField : UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter name of recipe"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let dividerView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Lilecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topView)
        view.addSubview(bestImageView)
        view.addSubview(titleRecipeTeactsField)
        view.addSubview(dividerView)
        addConstraints()
        setupBasicUI()
    }
    //MARK: - Functions
    private func addConstraints() {
        let topViewConstraints = [
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
        ]
      
        NSLayoutConstraint.activate(topViewConstraints)
        let bestImageViewConstraints = [
            bestImageView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bestImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bestImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bestImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ]
        NSLayoutConstraint.activate(bestImageViewConstraints)
        let titleRecipeTeactsFieldConstraints = [
            titleRecipeTeactsField.topAnchor.constraint(equalTo: bestImageView.bottomAnchor, constant: 20),
            titleRecipeTeactsField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleRecipeTeactsField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            titleRecipeTeactsField.heightAnchor.constraint(equalToConstant: 50)

        ]
        NSLayoutConstraint.activate(titleRecipeTeactsFieldConstraints)
         
        let dividerViewConstraints = [
            dividerView.topAnchor.constraint(equalTo: titleRecipeTeactsField.bottomAnchor),
            dividerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dividerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(dividerViewConstraints)
        
    }
    private func setupBasicUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .systemBackground
    }
    
    
}
