//
//  MenuViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.07.2023.
//

import Foundation


import UIKit

class MenuViewController: UIViewController {
    //MARK: - Properties
    let headerView: PhotoInfoView = {
        let headerView = PhotoInfoView(frame: .zero, type: .menu)
        return headerView
        
    }()
    lazy var  messageView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "email", titleText: "Messges"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  rateView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: "Rate Us"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  shareView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "share", titleText: "Share App"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  contactView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "contact-mail", titleText: "Contact Us"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  privacyView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "privacy", titleText: "Privacy Policy"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var menuStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageView, rateView, shareView, contactView, privacyView])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(headerView)
        view.addSubview(menuStack)
        addConstraints()
    }
    //MARK: - Functions
    private func addConstraints() {
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 120),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
        let menuStackConstraints = [
            menuStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            menuStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            menuStack.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        NSLayoutConstraint.activate(menuStackConstraints)
    }
    


}