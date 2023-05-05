//
//  AddIngredientTableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.05.2023.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {
    //MARK: - Properties
static let identifier = "AddIngredientTableViewCell"
    
    static let height: CGFloat = 80
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "quantity / product"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSettingContentView()
        contentView.addSubview(textField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    //MARK: - Functions
    private func setupSettingContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
    }
    private func addConstraints() {
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }

}
