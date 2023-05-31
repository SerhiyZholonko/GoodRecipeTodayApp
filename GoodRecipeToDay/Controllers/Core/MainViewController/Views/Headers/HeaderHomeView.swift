//
//  HeaderHomeView.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class HeaderHomeView: UIView {
  
    let helloLabel: UILabel = {
       let label = UILabel()
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let questionLabel: UILabel = {
       let label = UILabel()
        label.text = "Whant, would you like to cook today?"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let photoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "woman")
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.systemGray.cgColor
        iv.layer.borderWidth = 3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
 
    init() {
         super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(helloLabel)
        addSubview(questionLabel)
        addSubview(photoImageView)
        addConstraints()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     func configure(viewModel: MainViewControllerViewModelProtocol) {
         viewModel.setUser { user in
             guard let user = user else { return }
             DispatchQueue.main.async {
                 self.helloLabel.text = "Hallo, \(user.username)" 
             }
         }
       
    }
    private func addConstraints() {
       let  helloLabelConstraints = [
        helloLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        helloLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
        helloLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(helloLabelConstraints)
        let photoImageViewConstraints = [
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalToConstant: 50),
            photoImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(photoImageViewConstraints)
        let questionLabelConstraints = [
            questionLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor),
            questionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            questionLabel.rightAnchor.constraint(equalTo: photoImageView.leftAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(questionLabelConstraints)
    }
}
