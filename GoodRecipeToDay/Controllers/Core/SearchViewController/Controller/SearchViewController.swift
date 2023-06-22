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
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()

    let noResultLabel: UIImageView = {
       let label = UIImageView()
        label.image = UIImage(named: "search-engine")
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var  searchCollectionViewController: SearchCollectionViewController = {
        let layout = InsetCollectionViewFlowLayout()
       let vc = SearchCollectionViewController(collectionViewLayout: layout)
        vc.delegate = self
        return vc
    }()
    
    
    //MARK: - Init
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(noResultLabel)
        setupBasicUI()
        addConstraints()
        addConstraintsnoResultLabel()
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

    }
    private func addConstraintsnoResultLabel() {
        NSLayoutConstraint.activate([
            noResultLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -100),
            noResultLabel.widthAnchor.constraint(equalToConstant: 150),
            noResultLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
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


//MARK: - Delegate

extension SearchViewController: SearchCollectionViewControllerDelegate {
    func didNoResult(isHitten: Bool) {
        DispatchQueue.main.async {[weak self] in
            self?.noResultLabel.isHidden = isHitten
        }
    }
}
