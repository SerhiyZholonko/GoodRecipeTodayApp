//
//  AuthViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.05.2023.
//

import UIKit

class AuthViewController: UIViewController {
    let mainImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "platter")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let authLabel: UILabel = {
       let label = UILabel()
        label.text = "Elevate your home \ncooking with our experty curated recipes"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 32,weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailButton: ImageTextButton = {
        let button = ImageTextButton(type: .email)
        button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        return button
    }()
    lazy var googleButton: ImageTextButton = {
        let button = ImageTextButton(type: .google)
        button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        return button
    }()
    lazy var appleButton: ImageTextButton = {
        let button = ImageTextButton(type: .apple)
        button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        return button
    }()
    let orUseLabel: UILabel = {
        let label = UILabel()
        label.text = "or use social media"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let haveAccountLabel : UILabel = {
        let label = UILabel()
        label.text = "Already have an account"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let signInLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(mainImageView)
        view.addSubview(authLabel)
        view.addSubview(emailButton)
        view.addSubview(googleButton)
        view.addSubview(appleButton)
        view.addSubview(orUseLabel)
        view.addSubview(orUseLabel)
        view.addSubview(haveAccountLabel)
        view.addSubview(signInLabel)

        addConstraints()
    }
    //MARK: - Functions
    private func addConstraints() {
        let mainImageViewConstraints = [
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ]
        NSLayoutConstraint.activate(mainImageViewConstraints)
       
        let authLabelConstraints = [
            authLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            authLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            authLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            authLabel.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(authLabelConstraints)
        
        let emailButtonConstraints = [
            emailButton.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 10),
            emailButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            emailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            emailButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(emailButtonConstraints)
        let orUseLabelConstraints = [
            orUseLabel.topAnchor.constraint(equalTo: emailButton.bottomAnchor),
            orUseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            orUseLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            orUseLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(orUseLabelConstraints)
        let googleButtonConstraints = [
            googleButton.topAnchor.constraint(equalTo: orUseLabel.bottomAnchor, constant: 10),
            googleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            googleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            googleButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(googleButtonConstraints)
        let appleButtonConstraints = [
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 10),
            appleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            appleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            appleButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(appleButtonConstraints)
         let haveAccountLabelConstraints = [
            haveAccountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            haveAccountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            haveAccountLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(haveAccountLabelConstraints)
        let signInLabelConstraints = [
            signInLabel.centerYAnchor.constraint(equalTo: haveAccountLabel.centerYAnchor),
            signInLabel.leftAnchor.constraint(equalTo: haveAccountLabel.rightAnchor, constant: 10),
            signInLabel.heightAnchor.constraint(equalToConstant: 50)
       ]
       NSLayoutConstraint.activate(signInLabelConstraints)
    }
    
    @objc private func didTapped() {
        print("Tap")
    }
}
