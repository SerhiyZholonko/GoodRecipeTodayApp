//
//  MessageCellViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.07.2023.
//

import UIKit


final class MessageCellViewModel {
    
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

    private var chat: Chat
    init(chat: Chat) {
        self.chat = chat
    }
}
