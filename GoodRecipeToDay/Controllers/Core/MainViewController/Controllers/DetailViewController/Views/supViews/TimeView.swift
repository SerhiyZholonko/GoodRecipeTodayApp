//
//  timeView.swift
//  GoodRecipeToDay
//
//  Created by apple on 17.05.2023.
//

import UIKit

class TimeView: UIView {
    //MARK: - Properties
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Time:"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let timeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(time text: String) {
        DispatchQueue.main.async {
            self.timeLabel.text = text
        }
    }

    private func  addConstraints() {
        
        let timeLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 70),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor)
        ]
        NSLayoutConstraint.activate(timeLabelConstraints)
        
        let titleLabelConstraints = [
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor)
            
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
