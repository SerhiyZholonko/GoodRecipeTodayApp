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
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Favorites", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Subscriptions", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
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
        label.textColor = .label
        return label
    }()
    let subscriptionsView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let subViewController = SubViewController()
    //MARK: - Livecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(subscriptionsView)
        addConstraints()
        addChildViewController(subViewController, to: subscriptionsView)
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriteCollection), name: .reloadFavoriteController, object: nil)
        reloadFavoriteCollection()
    }
  
    //MARK: - Functions
    private func setupBasicUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleLabel
    }
  
    private func addConstraints() {
        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
       let subscriptionsViewConstraints = [
        subscriptionsView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            subscriptionsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            subscriptionsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            subscriptionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(subscriptionsViewConstraints)
    }
    @objc func reloadFavoriteCollection() {
        
        viewModel.configure()
    }
    
    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            subscriptionsView.isHidden = true
        } else {
            subscriptionsView.isHidden = false
        }
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
