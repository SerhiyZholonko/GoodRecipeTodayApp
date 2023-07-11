//
//  SenderCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 07.07.2023.
//

import Foundation

final class SenderCellViewModel {
    //MARK: - Properties
    public var senderName: String {
        return username
    }
    
    private let username: String
    //MARK: - Init
    init(username: String) {
        self.username = username
    }

    //MARK: - Functions
}
