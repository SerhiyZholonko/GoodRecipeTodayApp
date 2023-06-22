//
//  PresentImageViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 22.05.2023.
//

import UIKit


struct PresentImageViewControllerViewModel {
   public var imageUrl: URL? {
       return URL(string: step.imageUrl ?? "")
    }
    public var description: String {
        return step.title
    }
    private var step: Step
    init(step: Step) {
        self.step = step
    }
  
}
