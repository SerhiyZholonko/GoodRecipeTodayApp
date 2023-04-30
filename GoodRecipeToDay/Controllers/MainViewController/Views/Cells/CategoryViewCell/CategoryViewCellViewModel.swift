//
//  CategoryViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import Foundation


final class CategoryViewCellViewModel {
    //MARK: - Properties
    var categories: [CategoryModel] = []
    
    init() {
        setupCategories()
    }
    private func setupCategories() {
        let newCategories: [CategoryModel] = [
            .init(name: "Breacfast", image: "english-breakfast"),
            .init(name: "Breacfast", image: "english-breakfast"),
            .init(name: "Breacfast", image: "english-breakfast"),
            .init(name: "Breacfast", image: "english-breakfast"),
        ]
        categories.append(contentsOf: newCategories)
    }
}
