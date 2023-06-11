//
//  CategoryColloctionViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import UIKit

class CategoryColloctionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CategoryColloctionViewCell"
    
    var viewModel: CategoryColloctionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.categoryImage.image = viewModel.image
                self?.categoryTitle.text = viewModel.title.uppercased()
            }
        }
    }
    
    let categoryImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemTeal
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let categoryTitle: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Livecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryImage)
        contentView.addSubview(categoryTitle)
        setupBasicUI()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewModel: CategoryColloctionViewCellViewModel) {
         self.viewModel = viewModel
    }
    private func setupBasicUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 20
    }
    private func addConstraints() {
        let categoryImageConstraints = [
            categoryImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            categoryImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ]
        NSLayoutConstraint.activate(categoryImageConstraints)
     
        let categoryTitleConstraints = [
            categoryTitle.topAnchor.constraint(equalTo: categoryImage.bottomAnchor),
            categoryTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            categoryTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            categoryTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(categoryTitleConstraints)
    }
  
    

}
