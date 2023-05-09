//
//  AuthButton.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.05.2023.
//

import UIKit



class ImageTextButton: UIButton {
    //MARK: - Properties
    private let type: ImageTextButtonType
     init(frame: CGRect, type: ImageTextButtonType) {
         self.type = type
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupButton() {
        // Set the spacing between the image and the title
        let spacing: CGFloat = 8.0
        
        // Set the image and title for the normal state
        setImage(type.image, for: .normal)
        setTitle(type.title, for: .normal)
        
        // Customize the appearance of the button
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: 0)
        self.configuration = config
        
        backgroundColor = .blue
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5.0
    }
}
