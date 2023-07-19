//
//  InstructionTableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 21.05.2023.
//

import UIKit
import SDWebImage

protocol InstructionTableViewCellDelegate: AnyObject {
    func showImage(viewModel: InstructionTableViewCellViewModel)
}

class InstructionTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: InstructionTableViewCellDelegate?
    var viewModel: InstructionTableViewCellViewModel?
    static let identifair = "InstructionTableViewCell"
    static let height: CGFloat = 100
    
    lazy var instructionImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let instructionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addGestureRecognizer(tapGestureRecognizer)
        addSubview(instructionImageView)
        addSubview(instructionLabel)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: InstructionTableViewCellViewModel ) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.instructionImageView.sd_setImage(with: viewModel.image)
            strongSelf.instructionLabel.text = viewModel.title
        }
    }
    private func addConstraints() {
       
        let instructionImageViewConstraints = [
            instructionImageView.heightAnchor.constraint(equalToConstant: 80),
            instructionImageView.widthAnchor.constraint(equalToConstant: 80),
            instructionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            instructionImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(instructionImageViewConstraints)
        let instructionLabelConstraints = [
            instructionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            instructionLabel.leftAnchor.constraint(equalTo: instructionImageView.rightAnchor, constant: 10),
            instructionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            instructionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(instructionLabelConstraints)
        // Set the content hugging priority
        instructionLabel.setContentHuggingPriority(.required, for: .vertical)

    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let viewModel = viewModel else { return }
        delegate?.showImage(viewModel: viewModel)
    }
}
