//
//  CheckView.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class CheckView: UIView {
//MARK: - Properties
     var isCheckmark: Bool = true
    lazy var checkImage: UIImageView = {
       let iv = UIImageView()
        iv.tintColor = .label
        iv.isHidden = isCheckmark
        iv.contentMode = .scaleAspectFit
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
            let symbolImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
            iv.image = symbolImage

        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    //MARK: - Init
     init() {
         super.init(frame: .zero)
         addSubview(checkImage)
         configure()
         addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func changeCheckmark() {
        isCheckmark.toggle()
        checkImage.isHidden = isCheckmark
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func addConstraints() {
        let checkImageConstraints = [
            checkImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            checkImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            checkImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            checkImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(checkImageConstraints)
    }
    

}
