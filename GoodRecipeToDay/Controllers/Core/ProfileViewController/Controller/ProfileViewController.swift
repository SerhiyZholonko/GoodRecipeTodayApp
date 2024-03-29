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
        let view = PhotoInfoView(frame: .zero, type: .profile)
        view.editImageButton.isHidden = true
        view.delegate = self
        return view
    }()
    var isLoadData: Bool = false
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
        collectionView.register(FooterLodingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLodingCollectionReusableView.identifier)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPhotoInfoView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoInfoView)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        collectionView.addSubview(noRecipeLabel)
        setupBasicUI(isEdit: viewModel.isEdit)
        addConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        
        photoInfoView.viewModel?.getUser()
        viewModel.configure()

    }

    private func setupBasicUI(isEdit: Bool) {
        title = viewModel.title
        view.backgroundColor = .systemBackground
        
        let rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(didTappedSignOut))
        rightBarButtonItem.tintColor = UIColor.label

        let rightTitleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
        ]
        
        rightBarButtonItem.setTitleTextAttributes(rightTitleTextAttributes, for: .normal)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEdit))
        
        let leftTitleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
        ]
        
        if !isEdit {
            leftBarButtonItem.tintColor = .red
        } else {
            leftBarButtonItem.tintColor = UIColor.label
        }
        
        leftBarButtonItem.setTitleTextAttributes(leftTitleTextAttributes, for: .normal)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
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
    func showEditNameAlert() {
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            guard let strongSelf = self else { return }
            textField.placeholder = "Enter new name"
            textField.text = strongSelf.viewModel.username// Set the initial text if desired
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let newName = textField.text else {
                return
            }
            
            // Perform the necessary actions with the new name
            self?.viewModel.updateName(newName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

  
    @objc private func didTappedSignOut() {
        presentAlertOkCansel(massage: "Are you sure you want to sign out?")
        
        
    }
    @objc private func didTapEdit() {
        viewModel.changeEdit()
        setupBasicUI(isEdit: viewModel.isEdit)
        photoInfoView.editImageButton.isHidden = viewModel.isEdit
        photoInfoView.editNameButton.isHidden = viewModel.isEdit
    }
    
    @objc private func segmentedControlValueChanged() {
        if !viewModel.checkInternetConnection() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showErrorHUD("you have not internet connection")
              }
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.lastSnapshot = nil
            viewModel.recipes = []
            viewModel.isLastRecipeOfFollowers = false
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.fetchCurrentUserRecipe()
                }
            }
        } else {
            //TODO: - make func for update recipe
            viewModel.lastSnapshot = nil
            viewModel.recipes = []
            viewModel.isLastRecipeOfFollowers = false
            UIView.animate(withDuration: 0.5, delay: 1) {[weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.getRecipeFromFollowers()
                }
            }
        

        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !viewModel.checkInternetConnection() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showErrorHUD("you have not internet connection")
              }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if we need to load more data when reaching the last cell
        let selectedSection = self.segmentedControl.selectedSegmentIndex
        print(self.segmentedControl.selectedSegmentIndex)
        switch selectedSection {
        case 0:
            guard !viewModel.isLastRecipeOfCurrentuser else { return }
            if indexPath.item == viewModel.recipes.count - 1{
                isLoadData = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.viewModel.fetchCurrentUserRecipe()
                    self.isLoadData = false
                }
            }
           
        case 1:
            
            guard !viewModel.isLastRecipeOfFollowers else { return }
            if indexPath.item == viewModel.recipes.count - 1{
                isLoadData = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.viewModel.getRecipeFromFollowers()
                    self.isLoadData = false
                }
            }
          
        default:
            break
        }
       
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter.self else {
            fatalError("Unsupported")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLodingCollectionReusableView.identifier, for: indexPath)
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let selectedSection = self.segmentedControl.selectedSegmentIndex
        switch selectedSection {
        case 0:
            guard !isLoadData && !viewModel.isLastRecipeOfCurrentuser else {
                return .zero
            }
                return CGSize(width: collectionView.frame.width, height: 150)
        case 1:
            guard  !isLoadData && !viewModel.isLastRecipeOfFollowers else {
                return .zero
            }
                return CGSize(width: collectionView.frame.width, height: 150)
        default:
            return .zero
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.getRecipe(indexPath: indexPath)
        let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        UIView.animate(withDuration: 0.5) {
            self.present(navVC, animated: true)
        }
     
    }
}

// MARK: - delegate

extension ProfileViewController: PhotoInfoViewDelegate {
    func editName() {
        showEditNameAlert()
    }
    
    func sendMessges() {}
    
    func reloadPhotoInfoView() {
        photoInfoView.configure(viewModel: photoInfoView.viewModel ?? PhotoInfoViewViewModel(type: .profile))
    }
    
    func setPhotoImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                // Camera not available
                // Display an error message or alternative option
            }
        }
        actionSheet.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

    func presentAlertOkCansel(massage: String) {
        DispatchQueue.main.async {
            let alertVC = AlertControllerOKCansel(viewModel: AlertControllerOKCanselViewModel(massageText: massage))
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.delegate = self
            self.present(alertVC, animated: true)
        }
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
                    self.photoInfoView.configure(viewModel: PhotoInfoViewViewModel(type: .profile))


                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
        dismiss(animated: true, completion: nil)
    }
}



//MARK: - Delegate
 
//TODO:  - update photo
extension ProfileViewController: ProfileViewControllerViewModelDelegate {

    
    func updateUsername() {
        photoInfoView.viewModel?.getUser()
    }
    
    func updateRecipes() {
        collectionView.reloadData()
    }
}


extension ProfileViewController: RecipeDetailViewControllerDelegate {
    func reloadVM() {

    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}



extension ProfileViewController: AlertControllerOKCanselDelegate {
    func didSingOut() {
                viewModel.signOut()
        NotificationCenter.default.post(name: .signUp, object: nil, userInfo: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tabBarController?.selectedIndex = 0
        }

    }
    
    
}


