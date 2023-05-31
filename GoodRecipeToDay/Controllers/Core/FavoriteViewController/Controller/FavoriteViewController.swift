//
//  FavoriteViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    let viewModel = FavoriteViewControllerViewModel()

    
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
}

//MARK: - delegate collection view
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        cell.configure(viewModel: FavoriteCollectionViewCellViewModel(recipe: viewModel.recipes[indexPath.item]))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    
}


extension FavoriteViewController: FavoriteCollectionViewCellDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
