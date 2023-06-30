//
//  FilterView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func didTapReversButton()
}

class FilterView: UIView {
    //MARK: - Properties
    
    weak var delegate: FilterViewDelegate?
    
    private lazy var reversButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "arrow.left.arrow.right", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapReversButton), for: .touchUpInside)
        return button
    }()
    let diviredView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(diviredView)
        addSubview(reversButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
      let  diviredViewconstraints = [
            diviredView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            diviredView.leftAnchor.constraint(equalTo: leftAnchor),
            diviredView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            diviredView.widthAnchor.constraint(equalToConstant: 3)
        ]
        NSLayoutConstraint.activate(diviredViewconstraints)
        let filterButtonsConstraints = [
            reversButton.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            reversButton.leftAnchor.constraint(equalTo: diviredView.rightAnchor, constant: 3),
            reversButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10 ),
            reversButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3)
        ]
        NSLayoutConstraint.activate(filterButtonsConstraints)
    }
    @objc private func didTapReversButton() {
//        print("Test touch filter view")
        delegate?.didTapReversButton()
    }
}
