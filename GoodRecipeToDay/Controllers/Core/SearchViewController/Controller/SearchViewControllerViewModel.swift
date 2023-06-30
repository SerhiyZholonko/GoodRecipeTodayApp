//
//  SearchViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import Foundation

struct SearchViewControllerViewModel {
    let title = "Search"
    
    public var type: CheckmarkTextViewType {
        return typeForFilter
    }
    
    private var typeForFilter: CheckmarkTextViewType = .date

    //MARK: - Init
    
    //MARK: - Functions
    
    public mutating func setupType(type: CheckmarkTextViewType){
        self.typeForFilter = type
    }
    
    
}
