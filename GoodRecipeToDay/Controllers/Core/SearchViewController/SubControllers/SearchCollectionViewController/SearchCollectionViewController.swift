//
//  SearchCollectionViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 26.05.2023.
//

import UIKit

protocol SearchCollectionViewControllerDelegate: AnyObject {
    func didNoResult(isHitten: Bool)
}

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   //MARK: - Properties
    weak var delegate: SearchCollectionViewControllerDelegate?
   public var viewModel = SearchCollectionViewControllerViewModel() {
        didSet{
            collectionView.reloadData()
        }
    }
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        // Register cell classes
        self.collectionView!.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        viewModel.delegate = self
    }
    //MARK: - Functions
    public func updateviewModel(searchText: String) {
        self.viewModel.updateSearchText(newText: searchText)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !viewModel.checkInternetConnection() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showErrorHUD("you have not internet connection")
              }
        }
        if viewModel.recipes.count == 0 {
            delegate?.didNoResult(isHitten: false)
        } else {
            delegate?.didNoResult(isHitten: true)
        }
        return viewModel.recipes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        // Configure the cell
        cell.configure(viewModel: SearchCollectionViewCellViewModel(recipe: viewModel.getRecipe(indexParh: indexPath)))
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

           return UIEdgeInsets(top: 50, left: spacing, bottom: 50, right: spacing)
       }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let recipe = viewModel.getRecipe(indexParh: indexPath)
       
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


extension SearchCollectionViewController: SearchCollectionViewControllerViewModelDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}
extension SearchCollectionViewController: RecipeDetailViewControllerDelegate {
    func reloadVM() {
        
    }
    

    
    
}
