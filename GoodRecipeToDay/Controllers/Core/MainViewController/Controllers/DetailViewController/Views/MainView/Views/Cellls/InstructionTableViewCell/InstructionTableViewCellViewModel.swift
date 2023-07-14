//
//  InstructionTableViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 21.05.2023.
//

import Foundation


struct InstructionTableViewCellViewModel {
    public var image: URL? {
        guard let stringUrl = step.imageUrl else { return nil }
        return URL(string: stringUrl )
    }
    public var title: String {
        return step.title
    }
    public var instructionStep: Step {
        return step
    }
    public let indexPath: IndexPath
    private var step: Step
    init(step: Step, indexPath: IndexPath) {
        self.step = step
        self.indexPath = indexPath
    }
}
