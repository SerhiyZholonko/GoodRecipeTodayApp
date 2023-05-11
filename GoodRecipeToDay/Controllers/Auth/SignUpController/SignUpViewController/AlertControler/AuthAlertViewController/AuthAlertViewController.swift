//
//  AuthAlertViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class AuthAlertViewController: UIViewController {
//MARK: - Properties
    let viewModel: AuthAlertViewControllerViewModel
    let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var textAlertLabel: UILabel = {
       let label = UILabel()
        label.text = viewModel.massageText
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - Init
    init(viewModel: AuthAlertViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubview(alertView)
        alertView.addSubview(dismissButton)
        alertView.addSubview(textAlertLabel)
        addConstraints()
    }
//MARK: - Functions
    private func configure() {
        view.backgroundColor = .clear
    }
    private func addConstraints() {
        let alertViewConstraints = [
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(alertViewConstraints)
        let dismissButtonConstraints = [
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10),
            dismissButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.5),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(dismissButtonConstraints)
        
        let textAlertLabelConstraints = [
            textAlertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            textAlertLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10),
            textAlertLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10),
            textAlertLabel.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(textAlertLabelConstraints)
        
    }
    @objc private func didDismiss() {
        dismiss(animated: true)
    }
}






