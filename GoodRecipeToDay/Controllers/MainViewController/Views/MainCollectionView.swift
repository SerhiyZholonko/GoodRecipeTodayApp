//
//  MainCollectionView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

class MainCollectionView: UIView {
    public var collectionView: UICollectionView?
    private var viewModel: MainViewControllerViewModel
    private let spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.hidesWhenStopped = true
        spiner.translatesAutoresizingMaskIntoConstraints = false
        return spiner
    }()

    init(frame: CGRect, viewModel: MainViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(spiner)

        addSubview(collectionView)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - private
    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        addConstraintsSpiner()
        addConstaintsCollectionView(form: collectionView)
    }
    private func addConstraintsSpiner() {
        NSLayoutConstraint.activate([
            spiner.widthAnchor.constraint(equalToConstant: 100),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    private func addConstaintsCollectionView(form collectionView: UICollectionView) {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)

        ])
    }
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MainCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryHeader")
        collectionView.register(MainRecomendHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "recomendHeader")
        collectionView.register(MainWeekHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "weekHeader")
        return collectionView
        }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
       
    }
  
}
