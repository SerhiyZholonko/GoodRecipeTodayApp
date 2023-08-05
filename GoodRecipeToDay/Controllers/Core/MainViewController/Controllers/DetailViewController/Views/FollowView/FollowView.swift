//
//  FollowView.swift
//  GoodRecipeToDay
//
//  Created by apple on 30.07.2023.
//

import UIKit
import SDWebImage

protocol FollowViewDelegate: AnyObject {
    func forFollow(currentTitleForButton: String)
    func changeFollow()
    func showUserProfile(guser: GUser)
}


class FollowView: UIView {
    //MARK: - Properties
    weak var delegate: FollowViewDelegate?
    var viewModel: FollowViewViewModel
    
    let titleImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "welcome 1")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var currentUserImageView: UIImageView = {
       let iv = UIImageView()
//        iv.image = UIImage(named: "man-g755d62a6e_1280")
      
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let followImageView: UIImageView = {
       let iv = UIImageView()
//        iv.image = UIImage(named: "man-ge89afe6a4_1280")
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let arrowRoundImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "repeat")
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var photoStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [
        currentUserImageView,
        arrowRoundImageView,
        followImageView
       ])
        sv.distribution = .equalSpacing
        sv.axis = .horizontal
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var sendMessageButtom: UIButton = {
        let buttom = FollowButtom(type: .system)
        buttom.setTitle("Watch Profile", for: .normal)
        buttom.addTarget(self, action: #selector(didTouchProfileButton), for: .touchUpInside)

        return buttom
    }()
    lazy var followButtom: UIButton = {
        let buttom = FollowButtom(type: .system)
        buttom.setTitle("Follow", for: .normal)
        buttom.addTarget(self, action: #selector(didTouchFollowButton), for: .touchUpInside)
        return buttom
    }()

    //MARK: - Init

     init(viewModel: FollowViewViewModel) {
         self.viewModel = viewModel
         super.init(frame: .zero)
        setupBlurEffect()
        setupTapGestureRecognizer()
       
        addconstraints()
        
        setupObservers()
//         setupeAnimation()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
       

    }
    //MARK: - Functions
    public func setupeAnimation() {
        currentUserImageView.transform =  .init(rotationAngle: -30 * .pi / 180).concatenating(.init(translationX: 200, y: 0))
        followImageView.transform = .init(rotationAngle: -30 * .pi / 180).concatenating(.init(translationX: -200, y: 0))
        sendMessageButtom.transform = .init(translationX: -500, y: 0)
        followButtom.transform = .init(translationX: 500, y: 0)

        arrowRoundImageView.transform = .identity // Reset the transform to identity before each animation
        let rotationAngleInDegrees: CGFloat = 180.0
        let rotationAngleInRadians = rotationAngleInDegrees * .pi / 180.0

        UIView.animate(withDuration: 0.7) {
            self.currentUserImageView.transform = .identity
            self.followImageView.transform = .identity
          
        }

        UIView.animate(withDuration: 0.7) {
            self.arrowRoundImageView.transform = CGAffineTransform(rotationAngle: rotationAngleInRadians)
        }
        UIView.animate(withDuration: 0.9, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            self.sendMessageButtom.transform = .identity
            self.followButtom.transform = .identity
        }, completion: nil)

    }



    private func setupObservers() {
        
        // for currentUserImageView
        viewModel.currentUserObserver = { url in
            self.currentUserImageView.sd_setImage(with: url)
        }
        viewModel.followerUserUrlObserver = { url in
            self.followImageView.sd_setImage(with: url)
        }
        viewModel.followerUserObserver = { [weak self] user in
            guard let user = user else { return }
            self?.viewModel.user = user
        }
       
    }
    private func addconstraints() {
        addSubview(titleImageView)
        addSubview(currentUserImageView)
        addSubview(followImageView)
        addSubview(photoStackView)
        addSubview(sendMessageButtom)
        addSubview(followButtom)
        let titleImageViewConstrants = [
            titleImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 300),
            titleImageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(titleImageViewConstrants)
        let photoStackViewConstraints = [
            photoStackView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 20),
            photoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            photoStackView.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(photoStackViewConstraints)

       let sendMessageButtomConstraints = [
            sendMessageButtom.topAnchor.constraint(equalTo: photoStackView.bottomAnchor, constant: 40),
            sendMessageButtom.centerXAnchor.constraint(equalTo: centerXAnchor),
            sendMessageButtom.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            sendMessageButtom.heightAnchor.constraint(equalToConstant: 55)
       ]
        NSLayoutConstraint.activate(sendMessageButtomConstraints)
        
        
        let followButtomConstraints = [
            followButtom.topAnchor.constraint(equalTo: sendMessageButtom.bottomAnchor, constant: 10),
            followButtom.centerXAnchor.constraint(equalTo: centerXAnchor),
            followButtom.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            followButtom.heightAnchor.constraint(equalToConstant: 55)
        ]
         NSLayoutConstraint.activate(followButtomConstraints)
    }
    private func applyGradientBorder() {
        // Create a CAGradientLayer for the border
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = currentUserImageView.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor] // Customize the colors of the gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Adjust the gradient direction as needed
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Create a path for the border to match the rounded corners of the image view
        let borderPath = UIBezierPath(roundedRect: currentUserImageView.bounds, cornerRadius: 30).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = borderPath

        // Apply the mask to the gradient layer
        gradientLayer.mask = maskLayer

        // Add the gradient layer as a sublayer to the image view's layer
        currentUserImageView.layer.addSublayer(gradientLayer)
    }
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        // This is where you handle the dismiss action
        delegate?.forFollow(currentTitleForButton: "Follow")
    }
    @objc private func didTouchFollowButton() {
        delegate?.changeFollow()
    }
    @objc private func didTouchProfileButton() {
        
        guard let user = viewModel.user else { return }
            delegate?.showUserProfile(guser: user)
        
    }
}
