//
//  RecomendCollectionViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import UIKit
import SDWebImage

class RecomendCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "RecomendCollectionViewCell"
    private var viewModel: RecomendCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {[weak self] in
                self?.recipeImageView.sd_setImage(with: viewModel.imageUrl)
                self?.nameLabel.text = viewModel.title
                self?.timeView.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: viewModel.time))
                self?.rateView.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: viewModel.rate))
            }
           
        }
    }
    let mainView: UIView = {
       let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
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
    let rateView: ImageTextView = {
       let view = ImageTextView()
        view.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: "4.2(13)"))
        return view
    }()
    let timeView: ImageTextView = {
       let view = ImageTextView()
        view.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: "5:30"))
        return view
    }()
    let complicationView: BackgroundTextView = {
       let view = BackgroundTextView()
        view.configure(color: .systemGreen, textColor: .secondarySystemBackground, title: "Eazy")
        return view
    }()
    let stepsView: BackgroundTextView = {
       let view = BackgroundTextView()
        view.configure(color: .systemGreen.withAlphaComponent(0.3), textColor: .systemGreen, title: "4 steps")
        return view
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainView)
        contentView.addSubview(recipeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateView)
        contentView.addSubview(timeView)
        contentView.addSubview(complicationView)
        contentView.addSubview(stepsView)
        
        addConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any content that needs to be updated
        // For example, reset the text label
        recipeImageView.image = nil
        nameLabel.text = nil
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: RecomendCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
        let mainViewConstraints = [
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(mainViewConstraints)
        
      let recipeImageViewConstraints = [
            recipeImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            recipeImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            recipeImageView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
        NSLayoutConstraint.activate(recipeImageViewConstraints)
       let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: recipeImageView.rightAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)
        
        let rateViewConstraints = [
            rateView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            rateView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            rateView.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(rateViewConstraints)
        
        let timeViewConstraints = [
            timeView.centerYAnchor.constraint(equalTo: rateView.centerYAnchor),
            timeView.leftAnchor.constraint(equalTo: rateView.rightAnchor, constant: 8),
            timeView.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(timeViewConstraints)
        
       let complicationViewConstraints = [
            complicationView.topAnchor.constraint(equalTo: rateView.bottomAnchor, constant: 10),
            complicationView.leftAnchor.constraint(equalTo: rateView.leftAnchor),
            complicationView.widthAnchor.constraint(equalToConstant: 80),
            complicationView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(complicationViewConstraints)
        
        let stepsViewConstraints = [
            stepsView.topAnchor.constraint(equalTo: complicationView.topAnchor),
            stepsView.leftAnchor.constraint(equalTo: complicationView.rightAnchor, constant: 10),
            stepsView.widthAnchor.constraint(equalToConstant: 80),
            stepsView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(stepsViewConstraints)
        
        
    }
}
