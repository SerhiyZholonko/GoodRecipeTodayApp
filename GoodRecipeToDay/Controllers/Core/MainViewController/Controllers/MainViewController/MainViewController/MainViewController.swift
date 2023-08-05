//
//  MainViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit
import Reachability

protocol MainViewControllerDelegate: AnyObject {
    func touchDisMiss()
    func didTapMenuButton()
    func updateImageInMenu()
}

final class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    weak var delegate: MainViewControllerDelegate?
    
    var viewModel: MainViewControllerViewModel
    lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDarkViewTap(_:)))
        view.addGestureRecognizer(tapGesture)

        return view
    }()
    var  headerView: HeaderHomeView
    lazy var searchView: MainSearchView = {
       let view = MainSearchView()
        view.delegate = self
        return view
    }()
     var detailView: MainCollectionView
    private lazy var searchCollectionView: UIView = {
        let collectionView = UIView()
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureResignFirstResponder))
    let searchCollectionViewController = MainSearchCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    init() {
        viewModel = MainViewControllerViewModel()
        detailView = MainCollectionView(frame: .zero, viewModel: viewModel)
        headerView = HeaderHomeView()
        headerView.configure(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataMainController), name: .reloadMainViewControlelr, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(detailView)
        view.addSubview(searchCollectionView)
        view.addSubview(darkView)
        addConstraints()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        headerView.delegate = self
        addChildViewController(searchCollectionViewController, to: searchCollectionView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsernama), name: .updateUsername, object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  
    private func setupBasicUI() {
        view.backgroundColor = .secondarySystemBackground
        tapGesture.isEnabled = false // Disable the gesture recognizer initially
        view.addGestureRecognizer(tapGesture)
    }
    private func addConstraints() {
       let  headerViewConstraints = [
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 120)
       ]
        NSLayoutConstraint.activate(headerViewConstraints)
        let searchViewConstraints = [
            searchView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(searchViewConstraints)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        let searchCollectionViewConstraints = [
            searchCollectionView.topAnchor.constraint(equalTo: detailView.topAnchor),
            searchCollectionView.leftAnchor.constraint(equalTo: detailView.leftAnchor),
            searchCollectionView.rightAnchor.constraint(equalTo: detailView.rightAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(searchCollectionViewConstraints)
        let darkViewConstraints = [
            darkView.topAnchor.constraint(equalTo: view.topAnchor),
            darkView.leftAnchor.constraint(equalTo: view.leftAnchor),
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            darkView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(darkViewConstraints)
        
    }
    @objc private func handleDarkViewTap(_ gesture: UITapGestureRecognizer) {
        // Handle the tap gesture here
        // For example, you can toggle the visibility of the darkView or perform any other desired action
//        darkView.isHidden = true
        delegate?.touchDisMiss()
    }
    @objc func reloadDataMainController() {
            self.headerView.configure(viewModel: self.viewModel)
        delegate?.updateImageInMenu()
    }
    @objc func handleTapGestureResignFirstResponder() {
        searchView.searchTextField.resignFirstResponder()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        tapGesture.isEnabled = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tapGesture.isEnabled = false
    }
    @objc func updateUsernama() {
        self.headerView.configure(viewModel: self.viewModel)
    }

}


//MARK: - uicollectionView



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !viewModel.checkInternetConnection() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showErrorHUD("you have not internet connection")
              }
        }
        let sectionType = viewModel.sections[section]

        switch sectionType {
            
        case .category(let viewModel):
            return viewModel.count
        case .recomend(let viewModel):
            return viewModel.count > 4 ? 4 : viewModel.count
        case .oftheWeek(let viewModel):
            return viewModel.count > 4 ? 4 : viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .category(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(viewModel: viewModel[indexPath.item])
                return cell
        case .recomend(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendViewCell.identifier, for: indexPath) as? RecomendViewCell else { return UICollectionViewCell() }
            cell.configure(viewModel: viewModel[indexPath.item])
            return cell
        case .oftheWeek(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekViewCell.identiofier, for: indexPath) as? WeekViewCell else { return UICollectionViewCell() }
            cell.configure(viewModel: viewModel[indexPath.item])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
            
        case 0:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainCategoryHeaderView.identifier, for: indexPath) as?  MainCategoryHeaderView else { return UICollectionReusableView() }
            headerView.delegate = self
            return headerView
        case 1:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainRecomendHeaderView.identifier, for: indexPath) as? MainRecomendHeaderView else { return  UICollectionReusableView() }
            headerView.delegate = self
            return headerView
        case 2:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainWeekHeaderView.identifier, for: indexPath) as? MainWeekHeaderView else { return UICollectionReusableView() }
            headerView.delegate = self
            return headerView
        default:
                return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
            
        case .category(viewModel: let viewModel):
            
            let vc = CategoryViewController()
            vc.configure(viewModel: CategoryViewControllerViewModel(category: viewModel[indexPath.row].currentCategory))
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            UIView.animate(withDuration: 0.5) {
                self.present(navVC, animated: true)
            }
        case .recomend(viewModel: let viewModel):
            let recipe = viewModel[indexPath.item].recipe
            let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            UIView.animate(withDuration: 0.5) {
                self.present(navVC, animated: true)
            }
        case .oftheWeek(viewModel: let viewModel):
            let recipe = viewModel[indexPath.item].recipe
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
}
//MARK: - Delegate Header
extension MainViewController: MainWeekHeaderViewDelegate {
    func didTapReversionWeekRecipes() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.viewModel.sortedRecipeByDate()
        }
    }
    
    func didTapWeek() {
        let vc = RecipesOfTheWeekController()
        navigationController?.pushViewController(vc, animated: true)

    }
}

extension MainViewController: MainRecomendHeaderViewDelegate {
 
    func didTapReversionRecomend() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.viewModel.sortedRecipesByRate()
        }
        
    }
    
    func didTapRecomend() {
        let vc = RecomendViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MainViewController: MainCategoryHeaderViewDelegete {
    func didTapCategories() {
        let vc = CategoriesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Delegate viewModel

extension MainViewController: MainViewControllerViewModelDelegate {
    func reloadCollection() {
        detailView.collectionView?.reloadData()
        detailView.spiner.stopAnimating()
    }
}

//MARK: - Delegate search view

extension MainViewController: MainSearchViewDelegate {
    func filterRevers() {
        searchCollectionViewController.viewModel.changeRevers()
    }
    
    func dismissSearchView() {
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.searchCollectionView.alpha = 0
            
        }
    }
    func passSearchText(text: String) {
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.searchCollectionView.alpha = 1
            self.searchCollectionViewController.updateviewModel(searchText: text)
        }
    }
}

//MARK: - Delegate mainView

extension MainViewController: RecipeDetailViewControllerDelegate {
    func reloadVC() {
        viewModel = MainViewControllerViewModel()
    }
    
    func reloadCollectionView() {}
    
    func reloadVM() {
        viewModel = MainViewControllerViewModel()
    }
    
}


extension MainViewController: HeaderHomeViewDelegate {
    func photoImageViewTapped() {
        // Handle the photoImageView tap event in the main view controller
        delegate?.didTapMenuButton()
    }
}
