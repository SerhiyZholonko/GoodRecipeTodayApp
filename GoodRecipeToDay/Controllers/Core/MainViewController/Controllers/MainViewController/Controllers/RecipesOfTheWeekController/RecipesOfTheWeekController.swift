//
//  RecipesOfTheWeekController.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.06.2023.
//

import UIKit

class RecipesOfTheWeekController: UIViewController {
    //MARK: - Properties
    
    var viewModel = RecipesOfTheWeekControllerViewModel()
    
    lazy var reversFilterButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)

        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configuration), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didTapRevers))
        button.tintColor = .label
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipesOfTheWeekCell.self, forCellWithReuseIdentifier: RecipesOfTheWeekCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupBasicUI()
        addConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    //MARK: - Functions

    private func setupBasicUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.title
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = reversFilterButton


    }
    
    private func addConstraints() {
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    @objc private func didTapBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc private func didTapRevers() {
        
    }
}


//MARK: - delegate

extension RecipesOfTheWeekController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRecipesCount()

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesOfTheWeekCell.identifier, for: indexPath) as? RecipesOfTheWeekCell else { return UICollectionViewCell() }
        cell.configure(viewModel: .init(recipe: viewModel.getRecipe(indexParh: indexPath)))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = viewModel.getRecipe(indexParh: indexPath)
        let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
        vc.delegate = self

        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIView.animate(withDuration: 0.5) {
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size of each item (cell)
        // This will depend on the spacing and number of items per row you want
        let spacing: CGFloat = 30 // Adjust the spacing value as needed
        let numberOfItemsPerRow: CGFloat = 2 // Adjust the number of items per row as needed

        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
     let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: itemWidth, height: itemWidth )
    }
    // Implement the UICollectionViewDelegateFlowLayout method to specify the spacing around cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return the desired padding (spacing) around cells
        let spacing: CGFloat = 10 // Adjust the spacing value as needed

        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}


//MARK: - Delegate

extension RecipesOfTheWeekController: RecipesOfTheWeekControllerViewModelDelegate {
    func didFetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func didFail(with error: Error) {
        print("Error fetching data: \(error.localizedDescription)")
    }
    
    
}

extension RecipesOfTheWeekController:
    RecipeDetailViewControllerDelegate {
    func reloadVM() {
        
    }
    
        func reloadCollectionView() {
            collectionView.reloadData()
        }
        
        
    }
