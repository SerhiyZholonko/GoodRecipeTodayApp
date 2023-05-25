//
//  IsViewAgree.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.05.2023.
//

import UIKit

protocol IsViewAgreeDelegtae: AnyObject {
    func isAgree(agree: Bool)
}

class IsViewAgree: UIView {

  //MARK: - Properties
    weak var delegate: IsViewAgreeDelegtae?
    lazy var checkmarkView: CheckView = {
       let view = CheckView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedCheck)))
        return view
    }()
    let questionLabel: UILabel = {
       let label = UILabel()
        label.text = "I agree with"
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tConditersLabel: UILabel = {
        let label = UILabel()
         label.text = "Terms & Conditions"
         label.textColor = .label
         label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    //MARK: - Init
     init() {
        super.init(frame: .zero)
         translatesAutoresizingMaskIntoConstraints = false
         addSubview(checkmarkView)
         addSubview(questionLabel)
         addSubview(tConditersLabel)
         addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
     let checkmarkViewConstraints = [
        checkmarkView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
        checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
        checkmarkView.widthAnchor.constraint(equalToConstant: 30),
        checkmarkView.heightAnchor.constraint(equalToConstant: 30)
      ]
        NSLayoutConstraint.activate(checkmarkViewConstraints)
        
        let questionLabelConstraints = [
            questionLabel.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            questionLabel.leftAnchor.constraint(equalTo: checkmarkView.rightAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(questionLabelConstraints)
        
        let tConditersLabelConstraints = [
            tConditersLabel.leftAnchor.constraint(equalTo: questionLabel.rightAnchor,constant: 5),
            tConditersLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        NSLayoutConstraint.activate(tConditersLabelConstraints)
    }
    @objc private func didTappedCheck() {
        checkmarkView.changeCheckmark()
        delegate?.isAgree(agree: !checkmarkView.isCheckmark)
    }
}
