//
//  CookingStepModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.05.2023.
//

import UIKit

struct CookingTableViewCellViewModel {
    let instruction: String
    var image: UIImage?
    mutating func updateImage(image: UIImage) {
        self.image = image
    }
}
