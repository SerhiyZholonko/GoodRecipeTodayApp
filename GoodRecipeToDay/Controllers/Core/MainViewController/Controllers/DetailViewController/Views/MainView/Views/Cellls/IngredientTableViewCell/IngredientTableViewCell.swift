//
//  TableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 20.05.2023.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    //MARK: - Properties
    var viewModel: IngredientTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {[weak self] in
                print("Ingredients: ", viewModel.title)
                self?.ingredientLabel.text = viewModel.title
            }
        }
    }
    static let height: CGFloat = 50
    static let identifier: String = "TableViewCell"
    
    let ingredientLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
addSubview(ingredientLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewmodel: IngredientTableViewCellViewModel) {
        self.viewModel = viewmodel
    }
    
    private func addConstraints() {
       let  ingredientLabelConstraints = [
            ingredientLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            ingredientLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        NSLayoutConstraint.activate(ingredientLabelConstraints)
    }
}
