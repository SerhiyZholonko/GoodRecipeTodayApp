//
//  AuthTextField.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit



class AuthTextField: UITextField {
    //MARK: - Properties
    private let showPasswordButton = UIButton(type: .custom)
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    private let isSecure: Bool
    //MARK: - Init
    init(isSecure: Bool) {
        self.isSecure = isSecure
         super.init(frame: .zero)
        configure()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - functions
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        clipsToBounds = true
        autocorrectionType = .no
        autocapitalizationType = .none
        isSecurePassword()
    }
    
    private func isSecurePassword() {
        if isSecure {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            showPasswordButton.setTitle("  ", for: .normal)
            showPasswordButton.tintColor = .systemGray
                    showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
                    rightView = showPasswordButton
                    rightViewMode = .always
        }
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    @objc private func showPasswordButtonTapped() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }

}
