//
//  IntStringVerticalView.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import UIKit

class IntStringVerticalView: UIView {

    //MARK: - Properties
    var viewModel: IntStringVerticalViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {[weak self] in
                self?.numberLabel.text = viewModel.numberLabel
                self?.stringLabel.text = viewModel.titleLabel
            }
        }
    }
    
    let numberLabel: UILabel = {
       let label = UILabel()
        label.text = "11"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let stringLabel: UILabel = {
       let label = UILabel()
        label.text = "Posts"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackView: UIStackView = {
      let sv = UIStackView(arrangedSubviews: [
      numberLabel,
      stringLabel
      ])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(viewModel: IntStringVerticalViewViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
