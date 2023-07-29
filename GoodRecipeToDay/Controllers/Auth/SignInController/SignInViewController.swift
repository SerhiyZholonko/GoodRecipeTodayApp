//
//  SignInViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit
import JGProgressHUD


class SignInViewController: UIViewController {
    //MARK: - Properties
    let viewModel = SignInViewControllerViewModel()
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        return button
    }()

    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Sign In"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var signInButton: AuthButton = {
        let button = AuthButton(backgroundColor: .systemGreen, title: "Sign In")
        button.addTarget(self, action: #selector(didTappedSignIn), for: .touchUpInside)
        return button
    }()
    let nameView = AuthView(type: .name)
    let passwordView = AuthView(type: .password)
    lazy var authViewStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
       nameView,
       passwordView
       ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addConstraints()
        viewModel.delegate = self
    }
    
    //MARK: - Functions
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(authViewStack)
        view.addSubview(signInButton)
        nameView.delegate = self
        passwordView.delegate = self
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
                   authViewStack.heightAnchor.constraint(equalToConstant: 200)
               ]
               NSLayoutConstraint.activate(authViewStackConstraints)
            
               
               let signUpButtonConstraints = [
                   signInButton.topAnchor.constraint(equalTo: authViewStack.bottomAnchor, constant: 20),
                   signInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                   signInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                   signInButton.heightAnchor.constraint(equalToConstant: 50)
               ]
               NSLayoutConstraint.activate(signUpButtonConstraints)
               
               let backButtonConstraints = [
                   backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                   backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                   backButton.widthAnchor.constraint(equalToConstant: 30),
                   backButton.heightAnchor.constraint(equalToConstant: 30)
               ]
               NSLayoutConstraint.activate(backButtonConstraints)
    }

    @objc private func didTappedBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func didTappedSignIn() {
        viewModel.signIn{ [weak self] isSuccess in
            guard let strongSelf = self else { return }
            switch isSuccess {
                
            case .success():
                    strongSelf.navigationController?.popToRootViewController(animated: false)
                    NotificationCenter.default.post(name: .authVCClose, object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: .reloadMainViewControlelr, object: nil, userInfo: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }

            }
    }

}


//MARK: - Delegate
extension SignInViewController: AuthViewdelegate {
    func usernameDidChange(name: String?) {
        guard let name = name else { return }
        viewModel.username = name
            signInButton.isEnabled = viewModel.validation()
            signInButton.setupView()
    }
    func emailDidChange(email: String?) {
       
    }
    func passwordDidChange(password: String?) {
        guard let password = password else { return }
        viewModel.password = password
            signInButton.isEnabled = viewModel.validation()
            signInButton.setupView()
    }
}


//MARK: delegate SignInViewControllerViewModelDelegate
extension SignInViewController: SignInViewControllerViewModelDelegate {
    func forAlertError(error: Error) {
        showErrorHUD("Invalid, username or password")

    }
    
    
}
