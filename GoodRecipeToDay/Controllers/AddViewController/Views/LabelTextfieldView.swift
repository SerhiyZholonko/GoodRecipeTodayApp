//
//  LabelTextfieldView.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.05.2023.
//

import UIKit

protocol LabelTextfieldViewDelegate: AnyObject {
    func pushToPiker(type: LabelTextfieldViewType)
}

enum LabelTextfieldViewType {
    case category, quantity, cookingTime
    
    var titleLabel: String {
        switch self {
            
        case .quantity:
            return "quantity of person: "
        case .cookingTime:
            return "cooking time: "
        case .category:
            return "category: "
        }
    }
    var placeholder: String {
        switch self {
        case .quantity:
           return "Enter quantity"
        case .cookingTime:
            return "Enter time"
        case .category:
            return "Enter category"
        }
    }
    var keyboard: UIKeyboardType {
        switch self {
            
        case .quantity:
            return .numberPad
        case .cookingTime:
            return .default
        case .category:
            return .default
        }
    }
}

class LabelTextfieldView: UIView {
    
//MARK: - Properties
    weak var delegate: LabelTextfieldViewDelegate?
    let type: LabelTextfieldViewType
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text =  type.titleLabel
        label.textAlignment = .right
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = type.placeholder
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType =  type.keyboard
        tf.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedTF)))
        return tf
    }()
    //MARK: - Init
    init(frame: CGRect, type: LabelTextfieldViewType ) {
        self.type = type
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(textField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    @objc func didTappedTF() {
        delegate?.pushToPiker(type: type)
   }
}
