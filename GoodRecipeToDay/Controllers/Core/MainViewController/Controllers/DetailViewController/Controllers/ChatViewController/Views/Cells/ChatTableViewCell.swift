//
//  ChatTableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import UIKit

protocol ChatTableViewCellDelegate: AnyObject {
    func reloadTableView()
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
//                self?.delegate?.reloadTableView()
            }
        }
    }
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
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dateLabel)
        addSubview(massageLabel)
        addConstraints()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: ChatTableViewCellViewModel) {
        self.viewModel = viewModel
//        self.viewModel?.delegate = self
//        self.delegate?.reloadTableView()



    }
 
    private func addConstraints() {
      
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
        
       

    }
}


//MARK: - Delegate viewModel

extension ChatTableViewCell: ChatTableViewCellViewModelDelegate {
  
    func updateViewModel(viewModel: ChatTableViewCellViewModel) {
        self.viewModel = viewModel
        self.delegate?.reloadTableView()

    }
    
    
}

