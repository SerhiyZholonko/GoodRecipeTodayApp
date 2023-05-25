//
//  FilterView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

class FilterView: UIView {
    //MARK: - Properties
    let filterButtons: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checklist.unchecked"), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(filterButtons)
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
            filterButtons.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            filterButtons.leftAnchor.constraint(equalTo: diviredView.rightAnchor, constant: 3),
            filterButtons.rightAnchor.constraint(equalTo: rightAnchor, constant: -10 ),
            filterButtons.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3)
        ]
        NSLayoutConstraint.activate(filterButtonsConstraints)
    }
}
