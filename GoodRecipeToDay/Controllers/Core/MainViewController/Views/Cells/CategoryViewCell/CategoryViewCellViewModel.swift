//
//  CategoryViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.04.2023.
//

import UIKit


final class CategoryViewCellViewModel {
    // MARK: - Properties

       private var category: Categories
       
       var title: String {
           return category.title
       }
       
       var image: UIImage? {
           return category.image
       }
       
       var id: Int {
           return category.id
       }
       
    public var currentCategory: Categories {
        return category
    }
       // MARK: - Initialization
       
       init(category: Categories) {
           self.category = category
       }
}
