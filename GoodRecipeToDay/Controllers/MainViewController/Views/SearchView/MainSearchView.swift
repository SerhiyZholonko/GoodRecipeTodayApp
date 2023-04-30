//
//  MainSearchView.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class MainSearchView: UIView {

    let filterView: FilterView = {
       let view = FilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let searchTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Search any recipe"
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .systemGray3
       

        tf.leftView = iconView
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasicUI()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterView)
        addSubview(searchTextField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupBasicUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 25
        clipsToBounds = true
    }
    private func addConstraints() {
       let  filterViewConstrints = [
            filterView.topAnchor.constraint(equalTo: topAnchor),
            filterView.rightAnchor.constraint(equalTo: rightAnchor),
            filterView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterView.widthAnchor.constraint(equalToConstant: 50)

        ]
        NSLayoutConstraint.activate(filterViewConstrints)
        let searchTextFieldConstraints = [
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchTextField.rightAnchor.constraint(equalTo: filterView.leftAnchor)
        ]
        NSLayoutConstraint.activate(searchTextFieldConstraints)
    }
}
