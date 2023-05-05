//
//  Extension+TextView.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.05.2023.
//

import UIKit

extension UITextView: UITextViewDelegate {
    private struct Constants {
        static var placeholderKey = "placeholder"
    }
    
    public var placeholder: String? {
        get {
            return objc_getAssociatedObject(self, &Constants.placeholderKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &Constants.placeholderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.text = newValue
            self.textColor = .systemGray3
            self.delegate = self
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .systemGray3 else {
            return
        }
        
        textView.text = nil
        textView.textColor = .black
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty, let placeholder = placeholder else {
            return
        }
        
        textView.text = placeholder
        textView.textColor = .systemGray3
    }
}

