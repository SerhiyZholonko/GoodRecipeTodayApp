//
//  DescriptionView.swift
//  GoodRecipeToDay
//
//  Created by apple on 18.05.2023.
//

import UIKit

class DescriptionView: UIView {
    //MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Descriptions"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let descriptionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(descriptionsLabel)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(description text: String) {
        DispatchQueue.main.async {[weak self] in
            self?.descriptionsLabel.text = text
        }
    }
    private func addConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let descriptionsLabelConstraints = [
            descriptionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionsLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionsLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            descriptionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(descriptionsLabelConstraints)
    }
}
