//
//  ChatTableViewCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import Foundation
import Firebase

protocol ChatTableViewCellViewModelDelegate: AnyObject {
    func updateViewModel(viewModel: ChatTableViewCellViewModel)
}

final class ChatTableViewCellViewModel {
   
    
    //MARK: - Properties
    weak var delegate: ChatTableViewCellViewModelDelegate?
    
    let firebaseManager = FirebaseManager.shared
    
    public var massage: NSAttributedString {
        let boldAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .heavy)
        ]

        let mediumAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)
        ]
     
            let attributedString = NSMutableAttributedString(string: "\(chat.username ?? "no username") ")
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: chat.username?.count ?? 0))
        
        let titleAttributedString = NSAttributedString(string: chat.title, attributes: mediumAttributes)
        attributedString.append(titleAttributedString)
        
        return attributedString
    }
    public var date: String? {
        return createdDateString ?? "no date"
    }
    private var chat: Chat 
    //MARK: - Init
    init(chat: Chat) {
        self.chat = chat
    }
    //MARK: - Functions
    private var createdDateString: String? {
        guard let timestamp: Timestamp = chat.createdAt else { return nil }

        let currentDate = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(timestamp.dateValue()) {
            // If the timestamp is from today, display the time difference
            let components = calendar.dateComponents([.hour, .minute], from: timestamp.dateValue(), to: currentDate)
            
            if let hours = components.hour, hours > 0 {
                return "\(hours) hour\(hours > 1 ? "s" : "") ago"
            } else if let minutes = components.minute, minutes > 0 {
                return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
            } else {
                return "Just now"
            }
        } else {
            // If the timestamp is not from today, display the date difference
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            let dateString = dateFormatter.string(from: timestamp.dateValue())
            return "from \(dateString)"
        }
    }

}

