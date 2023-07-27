//
//  RecomendViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import UIKit

final class RecomendViewController: UIViewController {

    //MARK: - Properties

    var viewModel = RecomendViewControllerViewModel()
    var isLoadData: Bool = false

    // Search Controller
    let searchController = UISearchController(searchResultsController: nil)

    lazy var reversFilterButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)

        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configuration), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didTapRevers))
        button.tintColor = .label
        return button
    }()

   
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecomendCollectionViewCell.self, forCellWithReuseIdentifier: RecomendCollectionViewCell.identifier)
        collectionView.register(FooterLodingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLodingCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
 
    //MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: animated)
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupBasicUI()
        configureSearchController()
        addConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        
    }
    //MARK: - Functions

    private func setupBasicUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.title
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = reversFilterButton

    }
    private func configureSearchController() {
        // Configure Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        UIView.animate(withDuration: 0.4) {
            self.viewModel.changeRevers()
        }
    }
}
//MARK: - delegate

extension RecomendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendCollectionViewCell.identifier, for: indexPath) as? RecomendCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(viewModel: .init(recipe: viewModel.getRecipe(indexParh: indexPath)))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter.self else {
            fatalError("Unsupported")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLodingCollectionReusableView.identifier, for: indexPath)
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard !isLoadData && !viewModel.isLastRecipe else {
            return .zero
        }
            return CGSize(width: collectionView.frame.width, height: 150)
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
        let numberOfItemsPerRow: CGFloat = 1 // Adjust the number of items per row as needed

        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
     let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: itemWidth, height: itemWidth * 0.4)
    }
    // Implement the UICollectionViewDelegateFlowLayout method to specify the spacing around cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return the desired padding (spacing) around cells
        let spacing: CGFloat = 10 // Adjust the spacing value as needed

        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}


extension RecomendViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.filteredData = searchText.isEmpty ? viewModel.dataSource : viewModel.dataSource.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                    recipe.description.localizedCaseInsensitiveContains(searchText) ||
                    recipe.category.localizedCaseInsensitiveContains(searchText) ||
                    recipe.ingredients.contains { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
            collectionView.reloadData()
        }
    }
}

extension RecomendViewController: RecomendViewControllerViewModelDelegate {

    func didFetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func didFail(with error: Error) {
        print("Error fetching data: \(error.localizedDescription)")
    }
    
    
    
}


extension RecomendViewController: RecipeDetailViewControllerDelegate {
    func reloadVM() {
        
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    
}
