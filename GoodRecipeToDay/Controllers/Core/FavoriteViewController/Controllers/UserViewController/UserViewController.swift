//
//  UserViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 02.07.2023.
//

import UIKit

final class UserViewController: UIViewController {
    //MARK: - Properties
    
    private var viewModel: UserViewControllerViewModel
    
    lazy var photoInfoView: PhotoInfoView = {
        let view = PhotoInfoView(frame: .zero, type: .followers, user: viewModel.follower)
//        view.delegate = self
        return view
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyReipeCollectionViewCell.self, forCellWithReuseIdentifier: MyReipeCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        // Configure collection view properties as needed
        return collectionView
    }()
    let noRecipeLabel: UILabel = {
       let label = UILabel()
        label.text = "No Recipes"
        label.font = .boldSystemFont(ofSize: 18)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Livecycle
    init(viewModel: UserViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     

        view.addSubview(photoInfoView)
        view.addSubview(collectionView)
        collectionView.addSubview(noRecipeLabel)
        setupBasicUI()
        addConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self

    }

    private func setupBasicUI() {
        title = viewModel.title
        view.backgroundColor = .systemBackground
    
        navigationItem.rightBarButtonItem?.tintColor = UIColor.label
        navigationController?.navigationBar.tintColor = .label
    }

    // MARK: - Functions
    
    private func addConstraints() {
        let photoInfoViewConstraints: [NSLayoutConstraint]
          let screenHeightMultiplier: CGFloat
          
          let screenHeight = UIScreen.main.bounds.height
          
          if screenHeight >= 896 {
              // iPhone X, iPhone XS, iPhone 11 Pro, iPhone 12 Mini and newer
              screenHeightMultiplier = 0.3
          } else if screenHeight >= 812 {
              // iPhone XR, iPhone 11, iPhone 11 Pro Max, iPhone 12, iPhone 12 Pro
              screenHeightMultiplier = 0.28
          } else if screenHeight >= 736 {
              // iPhone 7 Plus, iPhone 8 Plus
              screenHeightMultiplier = 0.35
          } else if screenHeight >= 667 {
              // iPhone 7, iPhone 8, iPhone SE (2nd generation)
              screenHeightMultiplier = 0.35
          } else {
              screenHeightMultiplier = 0.3 // Default value for other devices
          }
          
          photoInfoViewConstraints = [
              photoInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              photoInfoView.leftAnchor.constraint(equalTo: view.leftAnchor),
              photoInfoView.rightAnchor.constraint(equalTo: view.rightAnchor),
              photoInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: screenHeightMultiplier)
          ]
          NSLayoutConstraint.activate(photoInfoViewConstraints)
        
     
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: photoInfoView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
        let noRecipeLabelConstraints = [
            noRecipeLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            noRecipeLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(noRecipeLabelConstraints)
    }
    

    
}

// MARK: - UICollectionViewDataSource

extension UserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the collection view
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReipeCollectionViewCell.identifier, for: indexPath) as? MyReipeCollectionViewCell else { return UICollectionViewCell() }
        // Configure the cell with data
        let recipe = viewModel.recipes[indexPath.item]
        cell.configure(viewModel: MyReipeCollectionViewCellViewModel(recipe: recipe))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size of each item (cell)
        // This will depend on the spacing and number of items per row you want
        let spacing: CGFloat = 30 // Adjust the spacing value as needed
        let numberOfItemsPerRow: CGFloat = 2 // Adjust the number of items per row as needed
        
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
    // Implement the UICollectionViewDelegateFlowLayout method to specify the spacing around cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return the desired padding (spacing) around cells
        let spacing: CGFloat = 10 // Adjust the spacing value as needed
        
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.getRecipe(indexPath: indexPath)
        let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
        vc.delegate = self
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIView.animate(withDuration: 0.5) {
            self.present(vc, animated: true)
        }
    }
    
}





//MARK: - Delegate

extension UserViewController: UserViewControllerViewModelDelegate {
    func updateRecipes() {
        collectionView.reloadData()
    }
}



extension UserViewController: RecipeDetailViewControllerDelegate {
    func reloadVM() {}
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}

