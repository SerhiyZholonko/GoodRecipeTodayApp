//
//  TitleTextView.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.06.2023.
//

import UIKit

class TitleTextView: UIView {
    //MARK: - Properties
    var viewModel: TitleTextViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.labelText
                self?.textLabel.text = viewModel.text
            }
        }
    }
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray3
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var labelTextStack: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [
        titleLabel,
        textLabel
        ])
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelTextStack)
        addconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: TitleTextViewViewModel) {
        self.viewModel = viewModel
    }
    private func addconstraints() {
       let labelTextStackConstraints = [
            labelTextStack.topAnchor.constraint(equalTo: topAnchor),
            labelTextStack.leftAnchor.constraint(equalTo: leftAnchor),
            labelTextStack.rightAnchor.constraint(equalTo: rightAnchor),
            labelTextStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(labelTextStackConstraints)
    }
}
