//
//  MainRecomendHeaderView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

protocol MainRecomendHeaderViewDelegate: AnyObject {
    func didTapRecomend()
    func didTapReversionRecomend()
}
class MainRecomendHeaderView: UICollectionReusableView {
    //MARK: - Properties
static let identifier = "MainRecomendHeaderView"
    
    var viewModel = MainRecomendHeaderViewViewModel()
    
    weak var delegate: MainRecomendHeaderViewDelegate?
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Recommendation"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var reversionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy, scale: .default)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: imageConfig), for: .normal)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didOnReversionButton), for: .touchUpInside)
        return button
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
        addSubview(reversionButton)
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
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let reversionButtonConstraints = [
            reversionButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8),
            reversionButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            reversionButton.widthAnchor.constraint(equalToConstant: 20),
            reversionButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(reversionButtonConstraints)
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
        delegate?.didTapRecomend()
    }
    @objc func didOnReversionButton() {
        delegate?.didTapReversionRecomend()
    }
}
