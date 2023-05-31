//
//  Extention+Timeshtamp.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.05.2023.
//

import Firebase

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
}
