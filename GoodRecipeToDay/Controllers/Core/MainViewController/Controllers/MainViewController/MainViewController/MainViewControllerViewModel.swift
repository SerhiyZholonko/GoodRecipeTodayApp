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


protocol MainViewControllerViewModelDelegate: AnyObject {
    func reloadCollection()
}
final class MainViewControllerViewModel {
    weak var delegate: MainViewControllerViewModelDelegate?
//    var completion: ((GUser?) -> Void)?
    let allCategories = Categories.allCases
    let firebaseManager = FirebaseManager.shared
    var title = "Home"
    private var isDateSorted: Bool = false {
        didSet {
            getingRecipes()
        }
    }
    private var isRateSorted: Bool = false {
        didSet {
            getingRecipes()
        }
    }
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
    public func setUser(complition: @escaping (GUser?) -> Void) {
        firebaseManager.fetchCurrentUser {  guser in
            complition(guser)
        }
    }

    @objc  func getingRecipes() {
        firebaseManager.getAllRecipes { result in
            switch result {
            case .success(let recipes):
                let newRecipes = recipes.sorted {  recipe1, recipe2 in
                   
                    let rate1 = recipe1.rate ?? 0.0
                    let rate2 = recipe2.rate ?? 0.0
                    let counter1 = recipe1.rateCounter
                    let counter2 = recipe2.rateCounter

                    let value1 = counter1 == 0 ? 0 : rate1 / Double(counter1)
                    let value2 = counter2 == 0 ? 0 : rate2 / Double(counter2)

                    return self.isRateSorted ? value1 > value2 : value1 < value2
                }
                let recomendRecipes = newRecipes.map{RecomendViewCellViewModel(recomendRecipe: $0)}
                self.recomendRecipes = recomendRecipes
                let weekRecipe = recipes.map{WeekViewCellViewModel(weekRecipe: $0)}
                self.weekRecipe = weekRecipe.sorted { self.isDateSorted ? $0.craetedDate > $1.craetedDate : $0.craetedDate < $1.craetedDate}
                self.delegate?.reloadCollection()
                //TODO: - filter recomend
            case .failure(_):
                print("error recomendRecipes")
            }
        }

    }
     private func uploadRecipes() {
         let categoryViewModels = allCategories.map { CategoryViewCellViewModel(category: $0) }
        self.sections = [
            .category(viewModel: categoryViewModels),
            .recomend(viewModel: recomendRecipes),
                .oftheWeek(viewModel: weekRecipe)
            ]
    }
    public func sortedRecipeByDate() {
        isDateSorted.toggle()
    }
    public func sortedRecipesByRate() {
        isRateSorted.toggle()
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
