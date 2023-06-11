//
//  RecipesOfTheWeekCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import UIKit
import SDWebImage

class RecipesOfTheWeekCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "RecipesOfTheWeekCellViewModel"
    
    private var viewModel: RecipesOfTheWeekCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.recipeImageView.sd_setImage(with: viewModel.imageUrl)
                self?.nameLabel.text = viewModel.name
                self?.dateLabel.text = viewModel.createdDateString
            }
        }
    }
    
    let recipeImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemPink
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "data"
        label.textColor = .systemGray3
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.addSubview(recipeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any content that needs to be updated
        // For example, reset the text label
        recipeImageView.image = nil
        nameLabel.text = nil
    }
    public func  configure(viewModel: RecipesOfTheWeekCellViewModel) {
        self.viewModel = viewModel
    }
    
    private func addConstraints() {
        let recipeImageViewConstraints = [
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor), recipeImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
        ]
        NSLayoutConstraint.activate(recipeImageViewConstraints)
        let nameLabelConstraints = [
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
        ]
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
}
