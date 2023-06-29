//
//  CategoryViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 24.05.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
//MARK: - Properties
   private var viewModel: CategoryViewControllerViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.title
            }
        }
    }
    let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var arrowBack: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: configuration), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(titleLabel)
        view.addSubview(arrowBack)
        view.addSubview(categoriesCollectionView)
        addConstraints()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        viewModel?.delegate = self

    }
    public func configure(viewModel: CategoryViewControllerViewModel) {
        self.viewModel = viewModel
    }

    //MARK: - Functions
    private func addConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        let arrowBackConstraints = [
            arrowBack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            arrowBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            arrowBack.widthAnchor.constraint(equalToConstant: 50),
            arrowBack.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(arrowBackConstraints)

        let categoriesCollectionViewConstraints = [
            categoriesCollectionView.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            categoriesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            categoriesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(categoriesCollectionViewConstraints)
    }

    @objc func didTappedBack() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.dismiss(animated: true)
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }

        guard let viewModel = viewModel else { return UICollectionViewCell() }
        cell.configure(viewModel: CategoryCellViewModel(recipe: viewModel.getRecipe(indexParh: indexPath)))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // Return the desired size of each item (cell)
           // This will depend on the spacing and number of items per row you want
           let spacing: CGFloat = 30 // Adjust the spacing value as needed
           let numberOfItemsPerRow: CGFloat = 2 // Adjust the number of items per row as needed

           let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: itemWidth, height: itemWidth * 1.5)
       }

       // Implement the UICollectionViewDelegateFlowLayout method to specify the spacing around cells
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           // Return the desired padding (spacing) around cells
           let spacing: CGFloat = 10 // Adjust the spacing value as needed

           return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let recipe = viewModel.getRecipe(indexParh: indexPath)
        let vc = RecipeDetailViewController(viewModel: .init(recipe: recipe) )
        vc.delegate = self

        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        UIView.animate(withDuration: 0.5) {
            self.present(vc, animated: true)
        }
    }
}


extension CategoryViewController: CategoryViewControllerViewModelDelegate {
    func didFetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.categoriesCollectionView.reloadData()
        }
    }

    func didFail(with error: Error) {
        print("Error fetching data: \(error.localizedDescription)")
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.categoriesCollectionView.reloadData()
        }
    }
}


//MARK: - delegate

extension CategoryViewController: RecipeDetailViewControllerDelegate {
    func reloadVM() {
    }
}
