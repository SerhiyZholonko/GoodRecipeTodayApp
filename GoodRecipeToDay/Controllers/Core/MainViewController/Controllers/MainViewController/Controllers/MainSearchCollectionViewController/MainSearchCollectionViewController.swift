//
//  SearchCollectionViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 25.05.2023.
//

import UIKit


class MainSearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var isLoadData: Bool = false
    var viewModel = MainSearchCollectionViewControllerViewModel()
    let emptyLabel: UIImageView = {
      let view = UIImageView()
        view.image = UIImage(named: "search-engine")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addSubview(emptyLabel)
       

        collectionView.register(FooterLodingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLodingCollectionReusableView.identifier)
        // Register cell classes
        self.collectionView!.register(MainSearchCollectionViewCell.self, forCellWithReuseIdentifier: MainSearchCollectionViewCell.identifier)
        addConstraints()
        collectionView.backgroundColor = .secondarySystemBackground
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(relosdMainSearchView), name: .reloadMainSearchController, object: nil)
    }
    public func updateviewModel(searchText: String) {
        self.viewModel.updateSearchText(newText: searchText)
    }

  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        emptyLabel.alpha = viewModel.filteredData.isEmpty ? 1 : 0
        return viewModel.filteredData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSearchCollectionViewCell.identifier, for: indexPath) as? MainSearchCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(viewModel: MainSearchCollectionViewCellViewModel(recipe: viewModel.getRecipe(indexParh: indexPath)))
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter.self else {
            fatalError("Unsupported")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLodingCollectionReusableView.identifier, for: indexPath)
        return footer
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
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if we need to load more data when reaching the last cell
        guard !viewModel.isLastRecipe else { return }
        if indexPath.item == viewModel.filteredData.count - 1{
            isLoadData = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isLoadData = false
                self.viewModel.getingRecipes()
                
            }
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let recipe = viewModel.getRecipe(indexParh: indexPath)
        let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
        vc.delegate = self
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIView.animate(withDuration: 0.5) {
            self.present(vc, animated: true)
        }
    }
       // Implement the UICollectionViewDelegateFlowLayout method to specify the spacing around cells
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           // Return the desired padding (spacing) around cells
           let spacing: CGFloat = 10 // Adjust the spacing value as needed

           return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard !isLoadData && !viewModel.isLastRecipe else {
            return .zero
        }
            return CGSize(width: collectionView.frame.width, height: 150)
    }
    private func addConstraints() {
        let emptyLabelConstraints = [
            emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            emptyLabel.widthAnchor.constraint(equalToConstant: 150),
            emptyLabel.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(emptyLabelConstraints)
    }
    @objc private func relosdMainSearchView() {
        collectionView.reloadData()
    }
}

extension MainSearchCollectionViewController: MainSearchCollectionViewControllerViewModelDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}



extension MainSearchCollectionViewController: RecipeDetailViewControllerDelegate {
  
    
    func reloadVM() {
        
    }
    
   
}
