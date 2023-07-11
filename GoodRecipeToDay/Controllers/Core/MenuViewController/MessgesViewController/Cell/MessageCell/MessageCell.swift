//
//  MessageCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.07.2023.
//

import UIKit

enum MessageCellType {
    case left
    case right
}

protocol MessageCellDelegate: AnyObject {
//    func reloadTableView()
    func cellHeightUpdated(for cell: MessageCell)
}

class MessageCell: UITableViewCell {
    //MARK: - Properties

    
    static let identifair = "MessageCell"
    
    var vieaModel: MessageCellViewModel?
    
    weak var delegate: MessageCellDelegate?

    var heightConstraint: NSLayoutConstraint!

    
    lazy var massageLabel: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .secondarySystemBackground
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        addSubview(massageLabel)

        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func congifure(viewModel: MessageCellViewModel) {
        self.vieaModel = viewModel
        DispatchQueue.main.async {
            
            self.massageLabel.attributedText = viewModel.massage
        }
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Calculate the height needed for the textLabel and update the height constraint
        let textLabelHeight = calculateTextLabelHeight()
        heightConstraint.constant = textLabelHeight
        
        // Notify the delegate (controller) about the updated height
        delegate?.cellHeightUpdated(for: self)
    }
    private func addConstraints() {
     
           let massageLabelConstraints = [
                massageLabel.topAnchor.constraint(equalTo: topAnchor),
                massageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                massageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                massageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
            NSLayoutConstraint.activate(massageLabelConstraints)
//        // Add a height constraint to the contentView
             heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
             heightConstraint.isActive = true

    }
    
    private func calculateTextLabelHeight() -> CGFloat {
        guard let text = massageLabel.text, let font = massageLabel.font else {
            return 0
        }
        
        let labelSize = CGSize(width: contentView.bounds.width - 32, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        
        let estimatedSize = NSString(string: text).boundingRect(with: labelSize, options: options, attributes: attributes, context: nil)
        
        return ceil(estimatedSize.height) + 16 // Add padding
    }


}
