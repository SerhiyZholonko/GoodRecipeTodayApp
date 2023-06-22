//
//  RecomendViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import UIKit
import SDWebImage

class RecomendViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "RecomendViewCell"
    let imageManager = FirebaseImageManager.shared
    let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
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
    override func prepareForReuse() {
          super.prepareForReuse()
          
          // Reset any content that needs to be updated
          // For example, reset the image and label text
          recipeImageView.image = nil
        titleLabel.text = nil
        userLabel.text = nil
      }
    //MARK: - Functions
    public func configure(viewModel: RecomendViewCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = viewModel.title
            self?.userLabel.text =  viewModel.usernmae
            self?.recipeImageView.sd_setImage(with: viewModel.imageUrl)

        }
    }
    private func addConstraints() {
       let recipeImageViewCostraints = [
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: leftAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: rightAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(recipeImageViewCostraints)
       let titleLabelConstraints = [
        titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
        titleLabel.heightAnchor.constraint(equalToConstant: 15)

        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
       let userLabelConstraints = [
            userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            userLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            userLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            userLabel.heightAnchor.constraint(equalToConstant: 14)

        ]
        NSLayoutConstraint.activate(userLabelConstraints)
    }
}
