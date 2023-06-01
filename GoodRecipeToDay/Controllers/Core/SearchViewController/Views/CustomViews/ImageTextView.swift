//
//  ImageTextView.swift
//  GoodRecipeToDay
//
//  Created by apple on 26.05.2023.
//

import UIKit

class ImageTextView: UIView {

    //MARK: - Properties
    var viewModel: ImageTextViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.customImageView.image = viewModel.image
                self?.titleLabel.text = viewModel.title
            }
        }
    }
    
    let customImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
//        label.text = "Title"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(customImageView)
        addSubview(titleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Functions
    public func configure(viewModel: ImageTextViewViewModel) {
        self.viewModel = viewModel
    }
    private func  addConstraints() {
        let customImageViewConstraints = [
            customImageView.leftAnchor.constraint(equalTo: leftAnchor),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 20),
            customImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(customImageViewConstraints)
        let titleLabelConstraints = [
            titleLabel.leftAnchor.constraint(equalTo: customImageView.rightAnchor, constant: 2),
            titleLabel.centerYAnchor.constraint(equalTo: customImageView.centerYAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
