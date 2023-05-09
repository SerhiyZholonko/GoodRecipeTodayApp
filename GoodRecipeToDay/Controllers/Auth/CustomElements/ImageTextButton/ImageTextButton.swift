//
//  AuthButton.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.05.2023.
//

import UIKit


final class ImageTextButton: UIButton {
    private var type: ImageTextButtonType
    lazy var buttonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = type.image
        iv.clipsToBounds = true
        iv.tintColor = .label
        return iv
    }()
    lazy var titlleLabel: UILabel = {
       let label = UILabel()
        label.text = type.title
        label.textColor = .label
        return label
    }()
    init(type: ImageTextButtonType) {
        self.type = type
         super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonImageView)
        addSubview(titlleLabel)
        clipsToBounds = true
        layer.cornerRadius = 25
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray3.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titlleLabel.sizeToFit()
        let buttonImageViewSize: CGFloat = 18
        let buttonImageX: CGFloat = (frame.size.width - titlleLabel.frame.size.width - buttonImageViewSize - 5) / 2
        buttonImageView.frame = CGRect(x: buttonImageX, y: (frame.size.height - titlleLabel.frame.size.height + 5) / 2, width: buttonImageViewSize, height: buttonImageViewSize)
        titlleLabel.frame = CGRect(x: buttonImageX + buttonImageViewSize + 5, y: (frame.size.height - buttonImageViewSize) / 2 , width: titlleLabel.frame.size.width, height: titlleLabel.frame.size.height)
    }
}

