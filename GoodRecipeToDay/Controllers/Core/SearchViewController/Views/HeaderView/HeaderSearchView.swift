//
//  HeaderView.swift
//  GoodRecipeToDay
//s
//  Created by apple on 26.05.2023.
//

import UIKit

protocol HeaderSearchViewDelegate: AnyObject {
    func passSearchText(text: String)
    func didTouchFilterButton()
}

class HeaderSearchView: UIView {
    
    //MARK: - Properties
    weak var delegate: HeaderSearchViewDelegate?

    
    var viewModel = HeaderSearchViewViewModel()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checklist.unchecked"), for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didTouchFilterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search any recipe"
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .systemGray3
        tf.delegate = self
        
        tf.leftView = iconView
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let divaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(filterButton)
        addSubview(divaderView)
        addSubview(searchTextField)
        setupUI()
        addConstraints()
        configure()
        searchTextField.resignFirstResponder()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
  
    private func configure() {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = self?.viewModel.title
        }
    }
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    private func addConstraints() {
        let titleLabelConstraint = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(titleLabelConstraint)
        let  filterViewConstrints = [
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            filterButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
            
        ]
        NSLayoutConstraint.activate(filterViewConstrints)
        let divaderViewConstraint = [
            divaderView.bottomAnchor.constraint(equalTo: filterButton.bottomAnchor),
            divaderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            divaderView.rightAnchor.constraint(equalTo: filterButton.leftAnchor, constant: -10),
            divaderView.heightAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(divaderViewConstraint)
        let searchTextFieldConstraints = [
            searchTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            searchTextField.bottomAnchor.constraint(equalTo: divaderView.topAnchor),
            searchTextField.rightAnchor.constraint(equalTo: filterButton.leftAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(searchTextFieldConstraints)
    }
    @objc private func didTouchFilterButton() {
        delegate?.didTouchFilterButton()
    }
    
}



extension HeaderSearchView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text, text.isEmpty {
//            delegate?.dismissSearchView()
//        }
        if let text = textField.text {
            delegate?.passSearchText(text: text)
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if let text = textField.text, text.isEmpty {
//            delegate?.dismissSearchView()
//        }
        if let text = textField.text {
            delegate?.passSearchText(text: text)
        }
        
    }
}

