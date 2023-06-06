//
//  WeekViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import UIKit
import SDWebImage

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
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
         label.text = "Date"
         label.textAlignment = .left
         label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userLabel: UILabel = {
        let label = UILabel()
         label.text = "By User"
         label.textAlignment = .left
         label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(recipeImageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(userLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewModel: WeekViewCellViewModel) {
        DispatchQueue.main.async {[weak self] in
            self?.titleLabel.text = viewModel.title
            self?.userLabel.text = viewModel.username
            self?.dateLabel.text = viewModel.createdDateString
            self?.recipeImageView.sd_setImage(with: viewModel.imageUrl)

        }
    }
    override func prepareForReuse() {
          super.prepareForReuse()
          
          // Reset any content that needs to be updated
          // For example, reset the image and label text
          recipeImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        userLabel.text = nil
      }
    private func addConstraints() {
        let recipeImageViewConstraints = [
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leftAnchor.constraint(equalTo: leftAnchor),
            recipeImageView.rightAnchor.constraint(equalTo: rightAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ]
        NSLayoutConstraint.activate(recipeImageViewConstraints)
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
       
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalToConstant: 15)
        ]
        NSLayoutConstraint.activate(dateLabelConstraints)
        let userLabelConstraints = [
            userLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            userLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            userLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            userLabel.heightAnchor.constraint(equalToConstant: 15)
        ]
        NSLayoutConstraint.activate(userLabelConstraints)
    }
}
