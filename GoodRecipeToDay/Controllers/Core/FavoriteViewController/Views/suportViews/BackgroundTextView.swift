//
//  BackgroundTextView.swift
//  GoodRecipeToDay
//
//  Created by apple on 31.05.2023.
//

import UIKit

class BackgroundTextView: UIView {

    //MARK: - Properties
    let contentView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        addSubview(titleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
       let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(contentViewConstraints)
        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    public func configure(color: UIColor, textColor: UIColor, title: String) {
        contentView.backgroundColor = color
        titleLabel.text = title
        titleLabel.textColor = textColor
    }
}
