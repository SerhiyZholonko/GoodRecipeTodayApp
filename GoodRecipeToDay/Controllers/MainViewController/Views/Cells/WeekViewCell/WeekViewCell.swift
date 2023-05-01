//
//  WeekViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import UIKit

class WeekViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identiofier = "WeekViewCell"
    let recipeImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "asparagus")
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userLabel: UILabel = {
        let label = UILabel()
         label.text = "By User"
         label.textAlignment = .center
         label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(recipeImageView)
        addSubview(titleLabel)
        addSubview(userLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewModel: WeekViewCellViewModel) {
        DispatchQueue.main.async {[weak self] in
            self?.recipeImageView.image = UIImage(named: viewModel.recomendRecipe.image)
            self?.titleLabel.text = viewModel.recomendRecipe.title
            self?.userLabel.text = viewModel.recomendRecipe.ceator
        }
    }
    private func addConstraints() {
        let recipeImageViewConstraints = [
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: leftAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: rightAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(recipeImageViewConstraints)
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let userLabelConstraints = [
            userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            userLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            userLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            userLabel.heightAnchor.constraint(equalToConstant: 15)
        ]
        NSLayoutConstraint.activate(userLabelConstraints)
    }
}
