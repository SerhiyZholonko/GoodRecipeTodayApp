//
//  TopGrayView.swift
//  GoodRecipeToDay
//
//  Created by apple on 15.07.2023.
//

import UIKit



class TopGrayView: UIView {

    //MARK: - Properties
    
    let topGayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(topGayView)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
        let topGayViewConstraints = [
            topGayView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            topGayView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topGayView.widthAnchor.constraint(equalToConstant: 50),
            topGayView.heightAnchor.constraint(equalToConstant: 3)
        ]
        NSLayoutConstraint.activate(topGayViewConstraints)
    }

}
