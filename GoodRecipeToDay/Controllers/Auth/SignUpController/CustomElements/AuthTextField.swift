//
//  AuthTextField.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class AuthTextField: UITextField {
    //MARK: - Properties
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
