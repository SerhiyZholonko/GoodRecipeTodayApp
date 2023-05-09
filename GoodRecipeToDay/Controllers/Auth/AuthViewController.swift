//
//  AuthViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.05.2023.
//

import UIKit

class AuthViewController: UIViewController {
    let mainImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "platter")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let authLabel: UILabel = {
       let label = UILabel()
        label.text = "Elevate your home \ncooking with our experty curated recipes"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 32,weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(mainImageView)
        view.addSubview(authLabel)
        addConstraints()
    }
    //MARK: - Functions
    private func addConstraints() {
        let mainImageViewConstraints = [
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ]
        NSLayoutConstraint.activate(mainImageViewConstraints)
        
        let authLabelConstraints = [
            authLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            authLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            authLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            authLabel.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(authLabelConstraints)
    }
}
