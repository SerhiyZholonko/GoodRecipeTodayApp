//
//  SearchViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
   private var viewModel = SearchViewControllerViewModel()

    lazy var headerView: HeaderSearchView = {
       let view = HeaderSearchView()
        view.delegate = self
        return view
    }()
    let collectionView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let collectionImageView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "wood")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let layout = InsetCollectionViewFlowLayout()
    lazy var searchCollectionViewController = SearchCollectionViewController(collectionViewLayout: layout)
    //MARK: - Init
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(collectionView)
        collectionView.addSubview(collectionImageView)
        setupBasicUI()
        addConstraints()
        addChildViewController(searchCollectionViewController, to: collectionView)
        NotificationCenter.default.addObserver(self, selector: #selector(relosdSearchView), name: .reloadSearchController, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // This will dismiss the keyboard and deselect the text field
    }
    //MARK: - Functions
    private func setupBasicUI() {
        title = viewModel.title
        view.backgroundColor = .secondarySystemBackground
    }
    private func addConstraints() {
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 50),
        ]
        NSLayoutConstraint.activate(collectionViewConstraints)
        let collectionImageViewConstraints = [
            collectionImageView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            collectionImageView.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            collectionImageView.rightAnchor.constraint(equalTo: collectionView.rightAnchor),
            collectionImageView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(collectionImageViewConstraints)
    }
    @objc private func relosdSearchView() {
        searchCollectionViewController.reloadCollectionView()
    }
}


//MARK: - header delegate
extension SearchViewController: HeaderSearchViewDelegate {
    func didTouchFilterButton() {
        let filterControllert = FilterController()
        filterControllert.delegate = self
        self.present(filterControllert, animated: true)
    }
    
    func passSearchText(text: String) {
        self.searchCollectionViewController.updateviewModel(searchText: text)
    }
    func dismissSearchView() {
    }
}


//MARK: - Delegate filter view

extension SearchViewController: FilterControllerDelegate {
    func getFilterType(type: CheckmarkTextViewType) {
        searchCollectionViewController.viewModel.setupType(type: type)
    }
}
