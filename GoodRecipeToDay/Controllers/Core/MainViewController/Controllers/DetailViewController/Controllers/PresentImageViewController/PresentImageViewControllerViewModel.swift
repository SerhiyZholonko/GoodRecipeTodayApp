//
//  PresentImageViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 22.05.2023.
//

import UIKit


struct PresentImageViewControllerViewModel {
   public var imageUrl: URL? {
       return URL(string: step[indexPath.row].imageUrl ?? "")
    }
    public var description: String {
        return step[indexPath.row].title
    }
    public var item: Int {
        return indexPath.item
    }
    private var step: [Step]
    private var indexPath: IndexPath
    init(step: [Step], indexPath: IndexPath) {
        self.step = step
        self.indexPath = indexPath
    }
    
    public func countInstruction() -> Int {
        return step.count
    }
    public mutating func updateAddingIndexPath() {
        indexPath.item = min(indexPath.item + 1, step.count - 1)
            print(indexPath.item)
        
    }
    public mutating func updateSubtractIndexPath() {
        indexPath.item = max(0, indexPath.item - 1 )
            print(indexPath.item)
    }
  
}
