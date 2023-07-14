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
        contentView.addSubview(instructionImageView)
        contentView.addSubview(instructionLabel)
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
            instructionImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            instructionImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            instructionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            instructionImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(instructionImageViewConstraints)
        let instructionLabelConstraints = [
            instructionLabel.leftAnchor.constraint(equalTo: instructionImageView.rightAnchor, constant: 10),
            instructionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            instructionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(instructionLabelConstraints)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let viewModel = viewModel else { return }
        delegate?.showImage(viewModel: viewModel)
    }
}
