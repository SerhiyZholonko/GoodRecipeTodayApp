//
//  MainRecomendHeaderView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

protocol MainRecomendHeaderViewDelegate: AnyObject {
    func didTapRecomend()
}
class MainRecomendHeaderView: UICollectionReusableView {
    //MARK: - Properties
static let identifier = "MainRecomendHeaderView"
    weak var delegate: MainRecomendHeaderViewDelegate?
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Recommendation"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let seeAllLabel: UILabel = {
       let label = UILabel()
        label.text = "See all"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGesture()
        addSubview(titleLabel)
        addSubview(seeAllLabel)
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func addConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let seeAllLabelConstraints = [
            seeAllLabel.topAnchor.constraint(equalTo: topAnchor),
            seeAllLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            seeAllLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(seeAllLabelConstraints)
    }
    fileprivate func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSeeAll))
        seeAllLabel.addGestureRecognizer(tapGesture)
        seeAllLabel.isUserInteractionEnabled = true
    }
    @objc  func didTapSeeAll() {
        print("Tap")
        delegate?.didTapRecomend()
    }
}
