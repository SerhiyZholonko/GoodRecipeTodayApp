//
//  AuthView.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

protocol AuthViewdelegate: AnyObject {
    func usernameDidChange(name: String?)
    func emailDidChange(email: String?)
    func passwordDidChange(password: String?)

}

class AuthView: UIView {
    //MARK: - Properties
    weak var delegate: AuthViewdelegate?
    private var type: AuthViewType
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = type.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var textField: AuthTextField = {
        let tf = AuthTextField(isSecure: type.isSecurityText)
        tf.placeholder = type.placeholder
        tf.delegate = self
        tf.keyboardType = type.keybourdType
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


extension AuthView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch type {
        case .name:
           delegate?.usernameDidChange(name: textField.text)
        case .email:
            delegate?.emailDidChange(email: textField.text )
        case .password:
            delegate?.passwordDidChange(password: textField.text)
        }
    }

}
