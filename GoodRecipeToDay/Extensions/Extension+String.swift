//
//  Extension+String.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.05.2023.
//

import Foundation


extension String {
    func convertToMinutes() -> Int? {
        let pattern = #"(\d{1,2})\s*h[^0-9]*?(\d{1,2})\s*m"# // Regular expression pattern
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        guard let match = matches.first,
              let hourRange = Range(match.range(at: 1), in: self),
              let minuteRange = Range(match.range(at: 2), in: self),
              let hours = Int(self[hourRange]),
              let minutes = Int(self[minuteRange]) else {
            return nil // Invalid format or non-numeric values
        }
        
        let totalMinutes = (hours * 60) + minutes
        return totalMinutes
    }
}


/// Usage TimeConverter
/* let timeString = "01h:01m"
TimeConverter.convertTimeStringToMinutes(timeString)
*/
final class TimeConverter {
    static let shared = TimeConverter()
     func convertTimeStringToMinutes(_ timeString: String, complition: @escaping (Int?) -> Void) {
        if let totalMinutes = timeString.convertToMinutes() {
            print(totalMinutes) // Output: 61
            complition(totalMinutes)
        } else {
            print("Invalid format")
            complition(nil)
        }
    }
}




