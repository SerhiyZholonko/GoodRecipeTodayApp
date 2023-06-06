//
//  IntStringVerticalViewViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import Foundation


final class IntStringVerticalViewViewModel {
    //MARK: - Properties
    public var numberLabel: String {
        return "\(number)"
    }
    public var titleLabel: String{
        return title
    }
    
    private let number: Int
    private let title: String
    
    //MARK: - Init
    init(number: Int, title: String) {
        self.number = number
        self.title = title
    }
}
