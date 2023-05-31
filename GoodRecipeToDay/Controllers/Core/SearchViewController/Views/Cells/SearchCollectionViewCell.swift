//
//  SearchCollectionViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 26.05.2023.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "SearchCollectionViewCell"
    
    private var viewModel: SearchCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.recipeImageView.sd_setImage(with: viewModel.mainImageUrl)
                self?.titleLabel.text = viewModel.title
                self?.rateView.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: "\(viewModel.rate)"))
                self?.timeView.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: "\(viewModel.time)"))

            }
        }
    }
    
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
    let rateView: ImageTextView = {
        let view = ImageTextView()
//        view.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: "4.5"))
        return view
    }()
    let timeView: ImageTextView = {
       let view = ImageTextView()
        view.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: "10m"))
        return view
    }()
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    lazy var bottonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        rateView,
        timeView,
        favoriteButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottonStackView)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(viewModel: SearchCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 20
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
        let bottonStackViewConstraints = [
            bottonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bottonStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            bottonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            bottonStackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(bottonStackViewConstraints)
    }
}
