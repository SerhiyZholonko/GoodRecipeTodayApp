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
                self?.rateView.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: viewModel.rate))
                self?.timeView.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: "\(viewModel.time)"))
                self?.dateLabel.text = viewModel.createdDateString
                self?.favoriteButton.tintColor = viewModel.checkIsFavorite() ? .systemPink : .label
                NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
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
        return view
    }()
    let timeView: ImageTextView = {
       let view = ImageTextView()
        view.configure(viewModel: ImageTextViewViewModel(imageName: "fast-time", titleText: "10m"))
        return view
    }()
    lazy var favoriteButton: UIButton = {
        let button = UIButton()

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "date"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .systemGray2
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var topBottonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        rateView,
        timeView,
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var bottonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            dateLabel,
        favoriteButton,
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
        contentView.addSubview(topBottonStackView)
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
        let topBottonStackViewConstraints = [
            topBottonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            topBottonStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            topBottonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            topBottonStackView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(topBottonStackViewConstraints)
        let bottonStackViewConstraints = [
            bottonStackView.topAnchor.constraint(equalTo: topBottonStackView.bottomAnchor),
            bottonStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            bottonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            bottonStackView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(bottonStackViewConstraints)
    }
    @objc private func didTapFavoriteButton() {
        guard let viewModel = viewModel else { return }
        if viewModel.checkIsFavorite() {
            viewModel.deleteWithFavorite()
            favoriteButton.tintColor = viewModel.checkIsFavorite() ? .systemPink : .black
            NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadMainSearchController, object: nil, userInfo: nil)
        } else {
            viewModel.saveInCoredata()
            favoriteButton.tintColor = viewModel.checkIsFavorite() ? .systemPink : .black
            NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadMainSearchController, object: nil, userInfo: nil)
        }
    }
}
