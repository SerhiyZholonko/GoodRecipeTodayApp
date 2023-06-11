//
//  MyReipeCollectionViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.06.2023.
//

import UIKit
import SDWebImage

class MyReipeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    var viewModel: MyReipeCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.title
                self?.dateLabel.text = viewModel.createdDateString ?? ""
                self?.recipeImageView.sd_setImage(with: viewModel.url)
            }
        }
    }
    static let identifier = "MyReipeCollectionViewCell"
    let recipeImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "3 jun 2023"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray5
        contentView.addSubview(recipeImageView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewModel: MyReipeCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
        let recipeImageViewConstraints = [
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            recipeImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ]
        NSLayoutConstraint.activate(recipeImageViewConstraints)
       let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
         ]
         NSLayoutConstraint.activate(dateLabelConstraints)
    }

}
