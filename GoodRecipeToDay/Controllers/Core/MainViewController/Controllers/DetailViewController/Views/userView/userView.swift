//
//  userView.swift
//  GoodRecipeToDay
//
//  Created by apple on 06.06.2023.
//

import UIKit

protocol UserViewDelegate: AnyObject {
    func followerBottonPressed()
}

class UserView: UIView {

    //MARK: - Properties
    weak var delegate: UserViewDelegate?
    
    var viewModel: UserViewViewModel? 
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.text = "by Username"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var followrButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isMultipleTouchEnabled = true
        addSubview(userLabel)
        addSubview(followrButton)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(isFollow: Bool, viewModel: UserViewViewModel) {
        self.viewModel = viewModel
        viewModel.delegate = self
        followrButton.tintColor = isFollow ?  .systemRed : .systemGreen
        followrButton.layer.borderColor = isFollow ?  UIColor.systemRed.cgColor : UIColor.systemGreen.cgColor
        followrButton.setTitle(isFollow ?  "Unfollow" : "Follow", for: .normal)
    }
    private func addConstraints() {
        let userLabelConstraints = [
            userLabel.leftAnchor.constraint(equalTo: leftAnchor),
            userLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userLabel.rightAnchor.constraint(equalTo: followrButton.leftAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(userLabelConstraints)
        let followButtonConstraints = [
            followrButton.widthAnchor.constraint(equalToConstant: 80),
            followrButton.heightAnchor.constraint(equalToConstant: 30),
            followrButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            followrButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(followButtonConstraints)
    }
    @objc  func didTapButton() {
        delegate?.followerBottonPressed()
    }
}


extension UserView: UserViewViewModelDelegate {
    func showButtonFollower(isShowButton: Bool) {
        followrButton.isHidden = isShowButton
    }
    
    
}
