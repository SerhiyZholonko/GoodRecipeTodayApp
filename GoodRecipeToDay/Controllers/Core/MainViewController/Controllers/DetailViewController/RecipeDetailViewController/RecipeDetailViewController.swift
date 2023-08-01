//
//  RecipeDetailViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 17.05.2023.
//

import UIKit

protocol RecipeDetailViewControllerDelegate: AnyObject {
    func reloadCollectionView()
    func reloadVM()
}

class RecipeDetailViewController: UIViewController {
    
    var mainViewTopConstraint: NSLayoutConstraint?

    weak var delegate: RecipeDetailViewControllerDelegate?
    var viewModel: RecipeDetailViewControllerViewModel
    

    lazy var mainImageView: UIImageView = {
       let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var arrowBack: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: configuration), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: configuration), for: .normal)
        button.backgroundColor = .white
        button.tintColor = viewModel.checkIsFavorite() ? .systemPink : .black
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var mainView: MainView = {
       let view = MainView()
        view.delegate = self
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var  followerView: FollowView = {
        let view = FollowView(viewModel: .init(followerUsername: viewModel.currentRecipe.username))
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var mainViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private lazy var chatViewController = ChatViewController(viewModel: ChatViewControllerViewModel(recipe: viewModel.currentRecipe))
    init(viewModel: RecipeDetailViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(true, animated: animated)
      }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainImageView)
          view.addSubview(arrowBack)
          view.addSubview(favoriteButton)
          view.addSubview(mainView)
          view.addSubview(followerView) // Add the followerView as a subview first

          setupUI()
          addConstraints()
          configure()

          NotificationCenter.default.addObserver(self, selector: #selector(didUpdateCoredata), name: .didUpdateCoredata, object: nil)
          self.addChildViewController(chatViewController, to: mainView.chatView)
    }
 
//MARK: - Functions
    func addBlurEffect(to view: UIView) {
         let blurEffect = UIBlurEffect(style: .dark)
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame = view.bounds
         view.addSubview(blurView)
     }
    private func calculateIngredientІackTableViewHeight() {
        let totalRowHeight = CGFloat(-140)
        mainViewHeightConstraint.constant = totalRowHeight
    }
    private func configure() {
        DispatchQueue.main.async { [weak self] in
            guard let strolngSelf = self else { return }
            strolngSelf.mainView.configure(recipe: strolngSelf.viewModel.currentRecipe)
            strolngSelf.mainImageView.sd_setImage(with: strolngSelf.viewModel.mainImageUrl)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        // Create the constraint and assign it to mainViewTopConstraint
           mainViewTopConstraint = mainView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -20)
           
           // Ensure the constraint is not nil
           guard let constraint = mainViewTopConstraint else {
               fatalError("Failed to create mainViewTopConstraint")
           }
           
           // Activate the constraint
           constraint.isActive = true
    }
    private func addConstraints() {
        let mainImageViewConstraints = [
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ]
        NSLayoutConstraint.activate(mainImageViewConstraints)
        
        let arrowBackConstraints = [
            arrowBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            arrowBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            arrowBack.widthAnchor.constraint(equalToConstant: 50),
            arrowBack.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(arrowBackConstraints)
        let favoriteButtonConstraints = [
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            favoriteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(favoriteButtonConstraints)
     

        let mainViewTopConstraint = mainView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -20)
        let mainViewConstraints = [
            mainViewTopConstraint,
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(mainViewConstraints)
        let followerViewConstraints = [
            followerView.topAnchor.constraint(equalTo: view.topAnchor),
            followerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            followerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            followerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(followerViewConstraints)
    }
 
    @objc private func didTappedBack() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.delegate?.reloadCollectionView()
            self.dismiss(animated: true)
        }
    }
    @objc private func didTapFavorite() {
        //TODO: - will save in coredata
        if viewModel.checkIsFavorite() {
            viewModel.deleteWithFavorite()
            favoriteButton.tintColor = viewModel.checkIsFavorite() ? .systemPink : .black
            NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadMainSearchController, object: nil, userInfo: nil)


        } else {
            viewModel.saveInCoredata()
            favoriteButton.tintColor = viewModel.checkIsFavorite() ? .systemPink : .black

            NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadMainSearchController, object: nil, userInfo: nil)

        }

        
    }

    @objc private func didUpdateCoredata() {
        didTapFavorite()
        NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)
        didTapFavorite()
    }
}


//MARK: - extention delegate


extension RecipeDetailViewController: MainViewDelegate {
    func showFollowView(title: String) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.followerView.followButtom.setTitle(title, for: .normal)
            self?.followerView.isHidden = false
        }
        followerView.setupeAnimation()

    }
    
  
    
    func changeSize() {
        guard let mainViewTopConstraint = mainViewTopConstraint else { return }
        if mainViewTopConstraint.constant == -20 {
            self.mainViewTopConstraint!.constant = -80
           } else {
               self.mainViewTopConstraint!.constant = -20
           }
           
           // Trigger layout updates
           UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
           }
    }
    

    func presentInstruction(step: [Step], indexPath: IndexPath) {
        let vc = PresentImageViewController()
        vc.modalPresentationStyle = .custom
        vc.configure(viewModel: PresentImageViewControllerViewModel(step: step, indexPath: indexPath))
        self.present(vc, animated: true)
    }
    
    func reloadVM() {
        delegate?.reloadVM()
    }
    
  
    
    func reloadChatView() {
        chatViewController.chatTableView.reloadData()
    }
    
 
}




extension RecipeDetailViewController: RecipeDetailViewControllerViewModelDelegate {
    func update(with viewModel: RecipeDetailViewControllerViewModel) {
        self.viewModel = viewModel
    }
    
    
}


extension RecipeDetailViewController: FollowViewDelegate {
    func showUserProfile(guser: GUser) {
        let vc = UserViewController(viewModel: UserViewControllerViewModel(user: guser, type: .watch))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeFollow() {
        mainView.changeFollow()
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.followerView.isHidden = true
        }
    }
    
    func forFollow(currentTitleForButton: String) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.followerView.isHidden = true
        }
    }
    
    
}
