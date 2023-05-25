//
//  CategoryCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 24.05.2023.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CategoryCell"
    
    private var viewModel: CategoryCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.categoryImage.sd_setImage(with: viewModel.mainImageUrl)
                self?.titleLabel.text = viewModel.title
                self?.usernameLabel.text = viewModel.username
            }
        }
    }
    
    let categoryImage: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: imageConfig), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(categoryImage)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(userImage)
        contentView.addSubview(usernameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: CategoryCellViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
       let categoryImageConstraints = [
            categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            categoryImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            categoryImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(categoryImageConstraints)
        let favoriteButtonConstraints = [
            favoriteButton.topAnchor.constraint(equalTo: categoryImage.topAnchor, constant: 10),
            favoriteButton.rightAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(favoriteButtonConstraints)
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: categoryImage.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let userImageConstraints = [
            userImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            userImage.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 30),
            userImage.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(userImageConstraints)
        let usernameLabelConstraints = [
            usernameLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            usernameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(usernameLabelConstraints)
    }
}
