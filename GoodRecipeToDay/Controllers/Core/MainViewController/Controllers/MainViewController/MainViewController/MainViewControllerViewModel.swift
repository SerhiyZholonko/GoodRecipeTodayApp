//
//  MainViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

enum SectionType {
    
    case category(viewModel: [CategoryViewCellViewModel])
    case recomend(viewModel: [RecomendViewCellViewModel])
    case oftheWeek(viewModel: [WeekViewCellViewModel])
}

protocol MainViewControllerViewModelProtocol: AnyObject {
    var sections: [SectionType] { get }
    var title: String { get }
    var completion: ((GUser?) -> Void)? {get set}
     init()
    var delegate: MainViewControllerViewModelDelegate? {get set}
     func uploadRecipes()
    func setUser(complition: @escaping (GUser?) -> Void )

     func createCategorySectionLayout() -> NSCollectionLayoutSection
     func createRecomendSectionLayout() -> NSCollectionLayoutSection
     func createOfTheWeekSectionLayout() -> NSCollectionLayoutSection
}
protocol MainViewControllerViewModelDelegate: AnyObject {
    func reloadCollection()
}
final class MainViewControllerViewModel: MainViewControllerViewModelProtocol {
    weak var delegate: MainViewControllerViewModelDelegate?
    var completion: ((GUser?) -> Void)?
    let allCategories = Categories.allCases
    let firebaseManager = FirebaseManager.shared
    var title = "Home"
    public var sections: [SectionType] = []
    private lazy var recomendRecipes: [RecomendViewCellViewModel] = [] {
        didSet {
           uploadRecipes()
            self.delegate?.reloadCollection()
        }
    }
    private lazy var weekRecipe: [WeekViewCellViewModel] = [] {
        didSet {
            uploadRecipes()
             self.delegate?.reloadCollection()
        }
    }
    //MARK: - init
    init() {
        getingRecipes()
        NotificationCenter.default.addObserver(self, selector: #selector(getingRecipes), name: .updateRecipes, object: nil)
    }
    //MARK: functions
    func setUser(complition: @escaping (GUser?) -> Void) {
        firebaseManager.fetchCurrentUser {  guser in
            complition(guser)
        }
    }

    @objc  private func getingRecipes() {
        firebaseManager.getAllRecipes { result in
            switch result {
            case .success(let recipes):
                self.recomendRecipes = recipes.map{.init(recomendRecipe: $0)}
                let weekRecipe = recipes.map{WeekViewCellViewModel(weekRecipe: $0)}
                self.weekRecipe = weekRecipe.sorted { $0.craetedDate > $1.craetedDate }
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
     func uploadRecipes() {
         let categoryViewModels = allCategories.map { CategoryViewCellViewModel(category: $0) }
        self.sections = [
            .category(viewModel: categoryViewModels),
            .recomend(viewModel: recomendRecipes),
                .oftheWeek(viewModel: weekRecipe)
            ]
    }
    //MARK: - layout
    
    public func createCategorySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        // Create the header item and add it to the section
         let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
         let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         section.boundarySupplementaryItems = [headerItem]
        return section
    }
    public func createRecomendSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // Create the header item and add it to the section
         let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
         let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         section.boundarySupplementaryItems = [headerItem]

        return section
    }
    public func createOfTheWeekSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(250)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Create the header item and add it to the section
         let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
         let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         section.boundarySupplementaryItems = [headerItem]
        return section
    }
}
