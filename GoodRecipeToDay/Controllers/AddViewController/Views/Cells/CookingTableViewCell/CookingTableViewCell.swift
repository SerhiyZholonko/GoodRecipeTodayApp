//
//  CookingTableViewCell.swift
//  GoodRecipeToDay
//
//  Created by apple on 03.05.2023.
//

import UIKit

protocol CookingTableViewCellDelegate: AnyObject {
    func didTappedImage(cell: CookingTableViewCell)
}

class CookingTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CookingTableViewCellDelegate?
    static let identifier = "CookingTableViewCell"
    static let height: CGFloat = 150
    
    let textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Give intructions"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var photoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "add")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        contentView.addSubview(textField)
        contentView.addSubview(photoImageView)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    //MARK: - Functions
    
    private func setupContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
    }
    private func addConstraints() {
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
        let photoImageViewConstraints = [
            photoImageView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            photoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ]
        NSLayoutConstraint.activate(photoImageViewConstraints)
    }
    
    @objc func didTapImage() {
        print("Tap cell")
        delegate?.didTappedImage(cell: self)
    }
            
}
