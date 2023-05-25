//
//  PresentImageViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 21.05.2023.
//


import UIKit
import SDWebImage

class PresentImageViewController: UIViewController {
    let currentImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(currentImageView)
        addConstraints()
        view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Functions
    public func configure(viewModel: PresentImageViewControllerViewModel) {
        DispatchQueue.main.async {
            self.currentImageView.sd_setImage(with: viewModel.imageUrl)
        }
    }
    private func addConstraints() {
        let currentImageConstraints = [
            currentImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(currentImageConstraints)
    }
    
    @objc private func didTapDismiss(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: currentImageView)
        if !currentImageView.bounds.contains(tapLocation) {
            dismiss(animated: true)
        }
    }
}
