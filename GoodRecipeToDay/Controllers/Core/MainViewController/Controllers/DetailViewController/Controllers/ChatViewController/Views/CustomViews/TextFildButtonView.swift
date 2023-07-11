//
//  TextFildButtonView.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import UIKit

protocol TextFildButtonViewDelegate: AnyObject {
    func massageSended(massage: String)
}
class TextFildButtonView: UIView {

    //MARK: - Properties
    var viewModel = TextFildButtonViewViewModel()
    
    weak var delegate: TextFildButtonViewDelegate?
    
     lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Message..."
        tf.backgroundColor = .systemGray3
        tf.layer.cornerRadius = 20
        tf.layer.borderColor = UIColor.systemGray.cgColor
        tf.layer.borderWidth = 2
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        // Create left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        
        // Create right padding view
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: tf.frame.height))
        tf.rightView = rightPaddingView
        tf.rightViewMode = .always
        
        return tf
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "arrow.up", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .systemGray3
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSendMassage), for: .touchUpInside)
        return button
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        addSubview(sendButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
        let sendButtonConstraints = [
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(sendButtonConstraints)
    }
    @objc private func didSendMassage() {
        delegate?.massageSended(massage: viewModel.massage)
        textField.text = ""
        
    }
}


//MARK: - Delegate

extension TextFildButtonView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            viewModel.massage = textField.text ?? ""
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            viewModel.massage = textField.text ?? ""
        }
    }
}
