//
//  RecipeDetailViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 17.05.2023.
//

import UIKit

protocol RecipeDetailViewControllerDelegate: AnyObject {
    func reloadCollectionView()
}

class RecipeDetailViewController: UIViewController {
    
    
    weak var delegate: RecipeDetailViewControllerDelegate?
    let viewModel: RecipeDetailViewControllerViewModel
    lazy var mainImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .systemBlue
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedMainImage)))
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
        button.tintColor = .black
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
    var mainViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    init(viewModel: RecipeDetailViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainImageView)
        view.addSubview(arrowBack)
        view.addSubview(favoriteButton)
        view.addSubview(mainView)
        setupUI()
        addConstraints()
        configure()
        
    }
//MARK: - Functions

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
     

        let mainViewConstraints = [
           
            mainView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -20),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(mainViewConstraints)
    }
    @objc private func didTappedBack() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.delegate?.reloadCollectionView()
            self.dismiss(animated: true)
        }
    }
    @objc private func didTapFavorite() {
        print("added to Favorite")
        //TODO: - will save in coredata
        viewModel.saveInCoredata()
        
    }
    @objc func didTappedMainImage() {
        let vc = PresentImageViewController()
        vc.configure(viewModel: PresentImageViewControllerViewModel(imageUrl: viewModel.mainImageUrl))
        self.present(vc, animated: true)
    }
}


//MARK: - extention delegate


extension RecipeDetailViewController: MainViewDelegate {
    func presentImage(viewModel: InstructionTableViewCellViewModel) {
        let vc = PresentImageViewController()
        vc.configure(viewModel: PresentImageViewControllerViewModel(imageUrl: viewModel.image))
        self.present(vc, animated: true)
    }
}
