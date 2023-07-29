//
//  AuthButton.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

class AuthButton: UIButton {
//MARK: - Properties
    private let title: String
    //MARK: - Init
  
    init(backgroundColor: UIColor, title: String) {
        self.title = title
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func configure() {
        layer.cornerRadius      = 10
        titleLabel?.textColor   = .white
        isEnabled = false
        setupView()
        tintColor = .white
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: titleLabel?.font.pointSize ?? 17)
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)

        setAttributedTitle(attributedTitle, for: .normal)
    }
    func setupView() {
        backgroundColor = isEnabled ? .systemGreen : .systemGray
    }
}
