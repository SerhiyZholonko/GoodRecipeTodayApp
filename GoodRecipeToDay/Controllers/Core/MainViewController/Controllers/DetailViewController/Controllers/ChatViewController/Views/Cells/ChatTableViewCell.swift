//
//  ChatTableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import UIKit

protocol ChatTableViewCellDelegate: AnyObject {
//    func reloadTableView()
    func cellHeightUpdated(for cell: ChatTableViewCell)
}

class ChatTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: ChatTableViewCellDelegate?
    static let identifier = "ChatTableViewCell"

    private var viewModel: ChatTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.massageLabel.attributedText = viewModel.massage
                self?.dateLabel.text = viewModel.date
            }
        }
    }
    
    var heightConstraint: NSLayoutConstraint!

    lazy var massageLabel: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0
        //TODO: - ?
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    let dateLabel: UILabel = {
       let label = UILabel()
//        label.text = "date"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Calculate the height needed for the textLabel and update the height constraint
        let textLabelHeight = calculateTextLabelHeight()
        heightConstraint.constant = textLabelHeight
        
        // Notify the delegate (controller) about the updated height
        delegate?.cellHeightUpdated(for: self)
        

    }
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConstraints()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addConstraints()

    }

    //MARK: - Functions
    public func configure(viewModel: ChatTableViewCellViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
//        self.delegate?.reloadTableView()
    }
 
    private func addConstraints() {
        addSubview(dateLabel)
        addSubview(massageLabel)
        let constraints = [
          
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                  dateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            massageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            massageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                  massageLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
            massageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

       
              ]

              NSLayoutConstraint.activate(constraints)
        
        // Add a height constraint to the contentView
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


//MARK: - Delegate viewModel

extension ChatTableViewCell: ChatTableViewCellViewModelDelegate {
  
    func updateViewModel(viewModel: ChatTableViewCellViewModel) {
        self.viewModel = viewModel

    }
    
    
}

