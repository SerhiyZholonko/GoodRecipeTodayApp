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

        // Add shadow
        view.layer.shadowColor = UIColor.green.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6

        return view
    }()

    let spiner: UIActivityIndicatorView = {
       let spiner = UIActivityIndicatorView(style: .large)
       spiner.color = .systemGreen
       spiner.startAnimating()
       spiner.translatesAutoresizingMaskIntoConstraints = false
       return spiner
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
        view.addSubview(spiner)
//        collectionView.addSubview(collectionImageView)
        setupBasicUI()
        addConstraints()
        addConstraintsSpiner()
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
    private func addConstraintsSpiner() {
        NSLayoutConstraint.activate([
            spiner.widthAnchor.constraint(equalToConstant: 100),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    @objc private func relosdSearchView() {
        searchCollectionViewController.reloadCollectionView()
        spiner.stopAnimating()
           spiner.isHidden = true
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
    func stopSppiner() {
        DispatchQueue.main.async {[weak self] in
            self?.spiner.stopAnimating()
            self?.spiner.isHidden = true
        }
    }
    
    
}
