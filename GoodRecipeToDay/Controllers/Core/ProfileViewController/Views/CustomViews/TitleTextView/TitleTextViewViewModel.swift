//
//  TitleTextViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.06.2023.
//

import Foundation


final class TitleTextViewViewModel {
    
    //MARK: - Properties
    public let labelText: String
    public let text: String
    init(labelText: String, text: String) {
        self.labelText = labelText
        self.text = text
    }
}
