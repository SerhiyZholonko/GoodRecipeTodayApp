//
//  FooterLodingCollectionReusableView.swift
//  GoodRecipeToDay
//
//  Created by apple on 24.07.2023.
//

import UIKit

final class FooterLodingCollectionReusableView: UICollectionReusableView {
    //MARK: - Properties
   static let identifier = "RMFooterLodingCollectionReusableView"
    
    private let spiner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
       addSubview(spiner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
        let spinerConstraints = [
         spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
         spiner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
         NSLayoutConstraint.activate(spinerConstraints)
    }
    
    
}
