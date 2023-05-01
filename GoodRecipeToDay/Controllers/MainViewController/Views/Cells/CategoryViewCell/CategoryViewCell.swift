//
//  CategoryViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    static let identifier = "CategoryViewCell"
    //MARK: - Properties
    let categoryImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "english-breakfast")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        addSubview(categoryImage)
        addSubview(titleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: CategoryViewCellViewModel) {
        DispatchQueue.main.async {
            self.categoryImage.image = UIImage(named: viewModel.category.image)
            self.titleLabel.text = viewModel.category.name
        }
    }
    private func addConstraints() {
        let categoryImageConstraints = [
            categoryImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            categoryImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            categoryImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            categoryImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(categoryImageConstraints)
       let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: categoryImage.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
}
