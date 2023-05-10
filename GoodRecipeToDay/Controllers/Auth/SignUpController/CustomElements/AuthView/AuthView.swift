//
//  AuthView.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class AuthView: UIView {
    //MARK: - Properties
    private var type: AuthViewType
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = type.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var textField: AuthTextField = {
       let tf = AuthTextField()
        tf.placeholder = type.placeholder
        tf.isSecureTextEntry = type.isSecurityText
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //MARK: - Init
    init(type: AuthViewType) {
        self.type = type
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(textField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func  addConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
}
