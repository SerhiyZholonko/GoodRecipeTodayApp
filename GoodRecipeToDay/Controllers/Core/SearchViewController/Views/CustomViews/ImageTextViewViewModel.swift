//
//  ImageTextViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 26.05.2023.
//

import UIKit


final class ImageTextViewViewModel {
    //MARK: - Properties
    public var image: UIImage? {
        return UIImage(named: imageName)
    }
    public var title: String {
        return titleText
    }
    private let imageName: String
    private let titleText: String
    //MARK: - Init
    init(imageName: String, titleText: String) {
        self.imageName = imageName
        self.titleText = titleText
    }
    //MARK: - Functions
}
