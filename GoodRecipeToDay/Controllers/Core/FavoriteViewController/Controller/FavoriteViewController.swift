//
//  FavoriteViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    var viewModel = FavoriteViewControllerViewModel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.viewModel.title
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
     
    //MARK: - Livecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
        view.addSubview(collectionView)
        addConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriteCollection), name: .reloadFavoriteController, object: nil)
    }
  
    //MARK: - Functions
    private func setupBasicUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleLabel
    }
  
    private func addConstraints() {
       let collectionViewConstraints = [
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    @objc func reloadFavoriteCollection() {
        viewModel.configure()
    }
}

//MARK: - delegate collection view
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        
        let recipe = viewModel.recipes[indexPath.item]
            cell.configure(viewModel: FavoriteCollectionViewCellViewModel(recipe: recipe))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    
}



//MARK: - delegate
extension FavoriteViewController: FavoriteCollectionViewCellDelegate {
    func deleteCell(cell: FavoriteCollectionViewCell) {
        if let cellIndexPath = collectionView.indexPath(for: cell) {
            viewModel.delete(indexPath: cellIndexPath)
            NotificationCenter.default.post(name: .reloadSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadMainSearchController, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .reloadFavoriteController, object: nil, userInfo: nil)

         }
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
extension FavoriteViewController: FavoriteViewControllerViewModelDelegate {
    
}
