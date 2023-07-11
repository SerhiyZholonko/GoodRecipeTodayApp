//
//  SenderCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 07.07.2023.
//

import UIKit

class SenderCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "SenderCell"
    
    private var viewModel: SenderCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {
                self.userLabel.configure(viewModel: ImageTextViewViewModel(imageName: "email", titleText: viewModel.senderName))
            }
        }
    }
    
    lazy var userLabel: ImageTextView = {
         let label = ImageTextView()
        label.backgroundColor = .secondarySystemBackground
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        addSubview(userLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func congifure(viewModel: SenderCellViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
       let userLabelConstraints =
        [userLabel.topAnchor.constraint(equalTo: topAnchor),
         userLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
         userLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
         userLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
         ]
        NSLayoutConstraint.activate(userLabelConstraints)
    }
}
