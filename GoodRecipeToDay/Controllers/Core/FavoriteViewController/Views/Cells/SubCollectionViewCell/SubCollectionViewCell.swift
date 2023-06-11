//
//  SubCollectionViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import UIKit
import SDWebImage

protocol SubCollectionViewCellDelegate: AnyObject {
    func reloadTableView()
}

class SubCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static var identifier = "SubCollectionViewCell"
    static var height: CGFloat = 100
    
    weak var delegate: SubCollectionViewCellDelegate?
    
    var viewModel: SubCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {[weak self] in
                self?.usernameLabel.text = viewModel.nameLabel
                self?.userImageView.sd_setImage(with: viewModel.urlInmage)
            }
        }
    }
        let userImageView: UIImageView = {
           let iv = UIImageView()
            iv.backgroundColor = .red
            iv.layer.cornerRadius = 25
            iv.clipsToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
     
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Unfollow", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didTapUnfollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: SubCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
        let userImageViewConstraints = [
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(userImageViewConstraints)
        
        let usernameLabelConstraints = [
            usernameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            usernameLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(usernameLabelConstraints)
        
        let followButtonConstraints = [
            followButton.heightAnchor.constraint(equalToConstant: 30),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(followButtonConstraints)
    }
    @objc private func didTapUnfollow() {
        viewModel?.deleteFollower()
        delegate?.reloadTableView()
    }
}
