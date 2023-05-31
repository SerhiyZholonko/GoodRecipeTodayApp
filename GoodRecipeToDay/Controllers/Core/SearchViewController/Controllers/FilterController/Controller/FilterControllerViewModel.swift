//
//  FilterControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.05.2023.
//

import Foundation

final class FilterControllerViewModel {
    //MARK: - Properties
    public var type: CheckmarkTextViewType {
        return typeForFilter
    }
    
    private var typeForFilter: CheckmarkTextViewType = .all

    //MARK: - Init
    
    //MARK: - Functions
    
    public func setupType(type: CheckmarkTextViewType) {
        self.typeForFilter = type
    }
}
