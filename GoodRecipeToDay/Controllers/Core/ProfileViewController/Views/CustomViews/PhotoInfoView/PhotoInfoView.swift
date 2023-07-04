//
//  PhotoInfoView.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.06.2023.
//
import UIKit
import SDWebImage


enum TypePhotoInfoView {
    case profile
    case followers
    case menu
}

protocol PhotoInfoViewDelegate: AnyObject {
    func setPhotoImageView()
    func reloadPhotoInfoView()
}

class PhotoInfoView: UIView {
    
    // MARK: - Properties
    weak var delegate: PhotoInfoViewDelegate?
    
    var viewModel: PhotoInfoViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf  = self  else { return }
                strongSelf.nameView.configure(viewModel: TitleTextViewViewModel(labelText: "name:", text: viewModel.username))
                strongSelf.emailView.configure(viewModel: TitleTextViewViewModel(labelText: "email:", text: viewModel.email))
                strongSelf.photoImageView.sd_setImage(with: URL(string: viewModel.stringUrl), placeholderImage: UIImage(named: "chef"))
                strongSelf.postsView.configure(viewModel: IntStringVerticalViewViewModel(number: viewModel.recipesCount, title: "Recipes"))

                strongSelf.followersView.configure(viewModel: IntStringVerticalViewViewModel(number: viewModel.followersCount, title: "Followers"))
                strongSelf.followingView.configure(viewModel: IntStringVerticalViewViewModel(number: viewModel.followingCount, title: "Followings"))
                strongSelf.delegate?.reloadPhotoInfoView()
            }
        }
    }
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var editImageButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: type == .followers ? 14 : 20, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: type == .followers ? "envelope" : "plus", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 25 / 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.isHidden = type == .menu ? true : false

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:  type == .followers ? #selector(didTapEmail) : #selector(didTapEdit), for: .touchUpInside)
        return button
    }()
    lazy var nameView: TitleTextView = {
        let view = TitleTextView()
        view.titleLabel.isHidden = type == .menu ? true : false
        view.textLabel.textAlignment = type == .menu ? .center : .left
        return view
    }()
    lazy var emailView: TitleTextView = {
        let view = TitleTextView()
        view.isHidden = type == .menu ? true : false
        return view
    }()
    
    let postsView: IntStringVerticalView = {
        let view = IntStringVerticalView()
        view.configure(viewModel: IntStringVerticalViewViewModel(number: 80, title: "Recipes"))
        return view
    }()
    let followersView: IntStringVerticalView = {
        let view = IntStringVerticalView()
        view.configure(viewModel: IntStringVerticalViewViewModel(number: 110, title: "Followers"))
        return view
    }()
    let followingView: IntStringVerticalView = {
        let view = IntStringVerticalView()
        view.configure(viewModel: IntStringVerticalViewViewModel(number: 150, title: "Following"))
        return view
    }()
    lazy var bottomViewStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            postsView,
            followersView,
            followingView
        ])
        sv.isHidden = type == .menu
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let type: TypePhotoInfoView
    private let user: GUser?
    // MARK: - Init
    init(frame: CGRect, type: TypePhotoInfoView = .profile, user: GUser? = nil) {
        self.type = type
        self.user = user
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        addSubview(editImageButton)
        addSubview(nameView)
        addSubview(emailView)
        addSubview(bottomViewStack)
        addConstraints()
        
        configure(viewModel: PhotoInfoViewViewModel(type: type, user: user))
        viewModel?.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    public func configure(viewModel: PhotoInfoViewViewModel) {
        self.viewModel = viewModel
    }
    private func addConstraints() {
        let photoImageViewConstraints = [
            photoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: type == .menu ? 0.3 : 0.25),
            photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: type == .menu ? 0.3 : 0.25),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(photoImageViewConstraints)
        let editImageButtonConstraints = [
            editImageButton.rightAnchor.constraint(equalTo: photoImageView.rightAnchor),
            editImageButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            editImageButton.widthAnchor.constraint(equalToConstant: 25),
            editImageButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(editImageButtonConstraints)
        let nameViewConstraints = [
            nameView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            nameView.leftAnchor.constraint(equalTo: leftAnchor, constant: type == .menu ? 0 : 40),
            nameView.rightAnchor.constraint(equalTo: rightAnchor, constant:  type == .menu ? 0 : -40),
            nameView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(nameViewConstraints)
        
        let emailViewConstaints = [
            emailView.topAnchor.constraint(equalTo: nameView.bottomAnchor),
            emailView.leftAnchor.constraint(equalTo: leftAnchor, constant: type == .menu ? 0 : 40),
            emailView.rightAnchor.constraint(equalTo: rightAnchor, constant: type == .menu ? 0 : -40),
            emailView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(emailViewConstaints)
        let bottomViewStackConstraints = [
            bottomViewStack.topAnchor.constraint(equalTo:  emailView.bottomAnchor, constant:  type == .menu ? -40 : 0),
            bottomViewStack.leftAnchor.constraint(equalTo: leftAnchor),
            bottomViewStack.rightAnchor.constraint(equalTo: rightAnchor),
            bottomViewStack.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(bottomViewStackConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeImageViewCircular()
    }
    
    private func makeImageViewCircular() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
        photoImageView.clipsToBounds = true
    }
    @objc private func didTapEdit() {
        delegate?.setPhotoImageView()
    }
    @objc private func didTapEmail() {
        print("Email")
    }
}




//MARK:  - delegate

extension PhotoInfoView: PhotoInfoViewViewModelDelegate {
    func updateUser(viewModel: PhotoInfoViewViewModel) {
        self.viewModel = viewModel
    }
    
 


}
