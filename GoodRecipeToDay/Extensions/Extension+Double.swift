//
//  Extension+Double.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.05.2023.
//

import Foundation


extension Double {
    func rounded(toDecimalPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

// Example usage
/*
let number = 3.14159
let roundedNumber = number.rounded(toDecimalPlaces: 2)
print(roundedNumber) // Output: 3.14
 */

