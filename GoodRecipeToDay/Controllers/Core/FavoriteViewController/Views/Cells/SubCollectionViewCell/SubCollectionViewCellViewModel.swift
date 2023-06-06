//
//  SubCollectionViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import UIKit

final class SubCollectionViewCellViewModel {
    //MARK: - Properties
    public var nameLabel: String {
        return name
    }
    public var urlInmage: URL? {
        guard let stringUrl = stringUrl else { return nil }
        return URL(string: stringUrl)
    }
    private let name: String
    private let stringUrl: String?
    init(name: String, stringUrl: String?) {
        self.name = name
        self.stringUrl = stringUrl
    }
}
