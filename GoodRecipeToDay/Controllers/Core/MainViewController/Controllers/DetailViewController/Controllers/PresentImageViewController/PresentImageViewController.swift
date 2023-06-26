//
//  PresentImageViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 21.05.2023.
//


import UIKit
import SDWebImage

class PresentImageViewController: UIViewController {
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let currentImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.layer.cornerRadius = 20
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.systemGray3.cgColor
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let backgroundDescription: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private  let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
             setBlur()
        
        view.addSubview(closeButton)
        view.addSubview(currentImageView)
        view.addSubview(backgroundDescription)
        backgroundDescription.addSubview(descriptionLabel)
        addConstraints()
        view.backgroundColor = .clear

    }
    
    // MARK: - Functions
    
    public func configure(viewModel: PresentImageViewControllerViewModel) {
        DispatchQueue.main.async {
            self.currentImageView.sd_setImage(with: viewModel.imageUrl)
            self.descriptionLabel.text = viewModel.description
        }
    }
    private func setBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    private func addConstraints() {
       let closeButtonConstraints = [
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(closeButtonConstraints)
        let currentImageConstraints = [
            currentImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            currentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(currentImageConstraints)
        let backgroundDescriptionconstraints = [
            backgroundDescription.topAnchor.constraint(equalTo: currentImageView.bottomAnchor, constant: 20),
            backgroundDescription.leftAnchor.constraint(equalTo: currentImageView.leftAnchor, constant: -20),
            backgroundDescription.rightAnchor.constraint(equalTo: currentImageView.rightAnchor, constant: 20),
            backgroundDescription.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(backgroundDescriptionconstraints)
       let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: backgroundDescription.topAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: backgroundDescription.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: backgroundDescription.rightAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: backgroundDescription.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
    
    @objc private func didTapDismiss(_ sender: UITapGestureRecognizer) {
            dismiss(animated: true)
    }
}
