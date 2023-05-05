//
//  TopBarView.swift
//  GoodRecipeToDay
//
//  Created by apple on 01.05.2023.
//

import UIKit

protocol TopBarViewDelegate: AnyObject {
    func saveRecipe()
    func closeView()
}

class TopBarView: UIView {
    //MARK: - Properties
    weak var delegate: TopBarViewDelegate?
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTappedClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTappedSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        addSubview(saveButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
       let closeButtonConstraints = [
            closeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(closeButtonConstraints)
        
        let saveButtonConstraints = [
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        NSLayoutConstraint.activate(saveButtonConstraints)
    }
    @objc func didTappedSave() {
        delegate?.saveRecipe()
    }
    @objc func didTappedClose() {
        delegate?.closeView()
    }
}
