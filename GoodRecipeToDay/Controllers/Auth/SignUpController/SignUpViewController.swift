//
//  SignUpViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class SignUpViewController: UIViewController {
    //MARK: - Properties
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Sign Up"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameView = AuthView(type: .name)
    let emailView = AuthView(type: .email)
    let passwordView = AuthView(type: .password)
    let agreeView = IsViewAgree()
    //MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    lazy var authViewStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
       nameView,
       emailView,
       passwordView
       ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let signUpButton: AuthButton = {
        let button = AuthButton(backgroundColor: .systemGreen, title: "Sign Up")
        return button
    }()
    let haveAccountLabel : UILabel = {
        let label = UILabel()
        label.text = "Already have an account"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var signInLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedSignIn)))
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addConstraints()
    }
    //MARK: - Functions
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(authViewStack)
        view.addSubview(agreeView)
        view.addSubview(signUpButton)
        view.addSubview(haveAccountLabel)
        view.addSubview(signInLabel)
    }
    private func addConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let authViewStackConstraints = [
            authViewStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            authViewStack.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            authViewStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            authViewStack.heightAnchor.constraint(equalToConstant: 260)
        ]
        NSLayoutConstraint.activate(authViewStackConstraints)
        let agreeViewConstraints = [
            agreeView.topAnchor.constraint(equalTo: authViewStack.bottomAnchor, constant: 10),
            agreeView.leftAnchor.constraint(equalTo: authViewStack.leftAnchor,constant: 10),
            agreeView.rightAnchor.constraint(equalTo: authViewStack.rightAnchor, constant: -10),
            agreeView.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(agreeViewConstraints)
        
        let signUpButtonConstraints = [
            signUpButton.topAnchor.constraint(equalTo: agreeView.bottomAnchor, constant: 20),
            signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(signUpButtonConstraints)
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
    @objc private func didTappedSignIn() {
        print("Tappp")
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
