//
//  ProfileViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//


import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    var viewModel = ProfileViewControllerViewModel()
    lazy var photoInfoView: PhotoInfoView = {
        let view = PhotoInfoView()
        view.delegate = self
        return view
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "My Recipes", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Subscriptions", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
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

    override func viewDidLoad() {
        super.viewDidLoad()
     

        view.addSubview(photoInfoView)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        collectionView.addSubview(noRecipeLabel)
        setupBasicUI()
        addConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        photoInfoView.viewModel?.getUser()
        viewModel.configure()
    }

    private func setupBasicUI() {
        title = viewModel.title
        view.backgroundColor = .systemBackground
        let barButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(didTappedSignOut))

        // Define the font attributes for the title text
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13) // Set the desired font size
        ]

        // Set the title text attributes for the bar button item
        barButtonItem.setTitleTextAttributes(titleTextAttributes, for: .normal)

        // Assign the modified bar button item to the rightBarButtonItem of the navigation item
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor.label
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
        
        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: photoInfoView.bottomAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(segmentedControlConstraints)
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
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
    
    @objc private func didTappedSignOut() {
        viewModel.signOut()
        
        tabBarController?.selectedIndex = 0
        
    }
    
    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.fetchCurrentUserRecipe()
                }
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.getRecipeFromFollowers()
                    print("Main recipe: ", self?.viewModel.recipes.count)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the collection view
        if viewModel.recipes.count == 0 {
            noRecipeLabel.isHidden = false
        } else  {
            noRecipeLabel.isHidden = true

        }
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

// MARK: - delegate

extension ProfileViewController: PhotoInfoViewDelegate {
    func reloadPhotoInfoView() {
//        photoInfoView.configure(viewModel: PhotoInfoViewViewModel())
    }
    
    func setPhotoImageView() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


//MARK: - extention, ImagePiker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
        if  let selectedImage = info[.originalImage] as? UIImage {
            photoInfoView.photoImageView.image = selectedImage
            viewModel.setImage(selectedImage) { result in
                switch result {
                    
                case .success():
                    print("Succussfully image")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
        dismiss(animated: true, completion: nil)
    }
}



//MARK: - Delegate

extension ProfileViewController: ProfileViewControllerViewModelDelegate {
    func updateRecipes() {
        collectionView.reloadData()
    }
}


extension ProfileViewController: RecipeDetailViewControllerDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}
