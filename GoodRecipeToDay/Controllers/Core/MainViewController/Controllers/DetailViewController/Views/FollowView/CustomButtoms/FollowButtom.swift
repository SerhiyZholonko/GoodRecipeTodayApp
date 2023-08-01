//
//  FollowButtom.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.07.2023.
//

import UIKit

class FollowButtom: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        applyGradient(colors: [UIColor.systemBlue.cgColor, UIColor.systemGreen.cgColor])
    }

  
}

