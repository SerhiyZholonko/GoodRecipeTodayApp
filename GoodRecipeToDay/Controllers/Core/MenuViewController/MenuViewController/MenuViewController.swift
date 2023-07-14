//
//  MenuViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.07.2023.
//

import Foundation


import UIKit
import SDWebImage
import StoreKit

protocol MenuViewControllerDelegate: AnyObject {
    func configureHeaderView()
}

class MenuViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: MenuViewControllerDelegate?
    
    var viewModel = MenuViewControllerViewModel()
    
    let firebaseManager = FirebaseManager.shared
    lazy var headerView: PhotoInfoView = {
        let headerView = PhotoInfoView(frame: .zero, type: .menu, user: viewModel.user)
        return headerView
    }()
    
    lazy var  messageView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "email", titleText: "Messges"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapMessage(_:)))
        itv.addGestureRecognizer(tapGesture)
        itv.isUserInteractionEnabled = true
        
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  rateView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "star", titleText: "Rate Us"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapRateUs(_:)))
        itv.addGestureRecognizer(tapGesture)
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  shareView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "share", titleText: "Share App"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapShare(_:)))
        itv.addGestureRecognizer(tapGesture)
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  contactView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "contact-mail", titleText: "Contact Us"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapContact(_:)))
        itv.addGestureRecognizer(tapGesture)
        itv.translatesAutoresizingMaskIntoConstraints = false
        return itv
    }()
    lazy var  privacyView: ImageTextView = {
        let itv = ImageTextView()
        itv.configure(viewModel: ImageTextViewViewModel(imageName: "privacy", titleText: "Privacy Policy"))
        itv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapPrivacy(_:)))
        itv.addGestureRecognizer(tapGesture)
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
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(headerView)
        view.addSubview(menuStack)
        addConstraints()
        
        
    }
    //MARK: - Functions
    public func setupImageAndName() {
        headerView.configure(viewModel: PhotoInfoViewViewModel(type: .menu, user: viewModel.user))
    }
    private func addConstraints() {
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 120),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
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
    
    @objc func handleTapMessage(_ gesture: UITapGestureRecognizer) {
        // Action to be performed when the gesture is recognized
        let vc = SenderViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    @objc func handleTapRateUs(_ gesture: UITapGestureRecognizer) {

            if let windowScene = view.window?.windowScene{
                SKStoreReviewController.requestReview(in: windowScene)
            
        }
    }
    
    @objc func handleTapShare(_ gesture: UITapGestureRecognizer) {
        UIGraphicsBeginImageContext(view.frame.size)
             view.layer.render(in: UIGraphicsGetCurrentContext()!)
             let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()

             let textToShare = "Check out my app"

             if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
                 let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
                 let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                 //Excluded Activities
                 activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
           

                 self.present(activityVC, animated: true, completion: nil)
             }
    }
    @objc func handleTapContact(_ gesture: UITapGestureRecognizer) {

       
    }
    @objc func handleTapPrivacy(_ gesture: UITapGestureRecognizer) {

       
    }
    
}
//delegate

extension MenuViewController: MenuViewControllerViewModelDelegate {
    func updateViewModel(viewModel: MenuViewControllerViewModel) {
        self.viewModel = viewModel
    }
}



