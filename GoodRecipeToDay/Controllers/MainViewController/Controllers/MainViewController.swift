//
//  MainViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    let viewModel = MainViewControllerViewModel()
    let headerView: HeaderHomeView = {
        let header = HeaderHomeView()
        return header
    }()
    let searchView: MainSearchView = {
       let view = MainSearchView()
        return view
    }()
    private let detailView: MainCollectionView

    init() {
        self.detailView = .init(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
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
        addConstraints()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    private func setupBasicUI() {
        view.backgroundColor = .secondarySystemBackground
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
    }
}


//MARK: - uicollectionView



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 8
        case 1:
            return 8
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else {
                return UICollectionViewCell()
            }
                return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendViewCell.identifier, for: indexPath) as? RecomendViewCell else { return UICollectionViewCell() }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekViewCell.identiofier, for: indexPath) as? WeekViewCell else { return UICollectionViewCell() }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainCategoryHeaderView.identifier, for: indexPath) as?  MainCategoryHeaderView else { return UICollectionReusableView() }
                headerView.delegate = self
                return headerView
            } else if indexPath.section == 1 {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainRecomendHeaderView.identifier, for: indexPath) as? MainRecomendHeaderView else { return  UICollectionReusableView() }
                headerView.delegate = self
                return headerView
            }else if indexPath.section == 2 {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainWeekHeaderView.identifier, for: indexPath) as? MainWeekHeaderView else { return UICollectionReusableView() }
                headerView.delegate = self
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
}



//MARK: - Delegate Header
extension MainViewController: MainWeekHeaderViewDelegate {
    func didTapWeek() {
        print("Week")
    }
}

extension MainViewController: MainRecomendHeaderViewDelegate {
    func didTapRecomend() {
        print("Recomend")
    }
}
extension MainViewController: MainCategoryHeaderViewDelegete {
    func didTapCategories() {
        print("Categories")
    }
    
  
}
