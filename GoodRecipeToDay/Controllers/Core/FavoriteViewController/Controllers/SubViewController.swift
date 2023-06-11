//
//  SubViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.06.2023.
//

import UIKit

class SubViewController: UIViewController {
    //MARK: - Properties
    var viewModel = SubViewControllerViewModel() {
        didSet {
            collectionView.reloadData()
        }
    }
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubCollectionViewCell.self, forCellWithReuseIdentifier: SubCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // Configure collection view properties as needed
        return collectionView
    }()
    //MARK: - Init
    
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        addConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
    }
    //MARK: - Functions
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


extension SubViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCollectionViewCell.identifier, for: indexPath) as? SubCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        let user = viewModel.getUser(indexPath: indexPath)
        cell.configure(viewModel: SubCollectionViewCellViewModel(user: user))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: SubCollectionViewCell.height)
    }
}


//MARK: - Delegate

extension SubViewController: SubCollectionViewCellDelegate {
    func reloadTableView() {
        viewModel.getAllFollowersForUser()
    }
}


extension SubViewController: SubViewControllerViewModelDelegate {
    func updateViewModel(viewModel: SubViewControllerViewModel) {
        self.viewModel = viewModel
    }
    
    
}
