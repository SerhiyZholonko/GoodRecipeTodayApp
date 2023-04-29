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
        view.backgroundColor = .systemBackground
    }
    private func addConstraints() {
       let  headerViewConstraints = [
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 120)
       ]
        NSLayoutConstraint.activate(headerViewConstraints)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemPink
        }
        else  if indexPath.section == 1 {
            cell.backgroundColor = .systemGreen
        }
        else  if indexPath.section == 2 {
            cell.backgroundColor = .systemYellow
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath)
                return headerView
            } else if indexPath.section == 1 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "recomendHeader", for: indexPath)
                return headerView
            }else if indexPath.section == 2 { 
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "weekHeader", for: indexPath)
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
}
