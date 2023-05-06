//
//  MainViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit


final class MainViewControllerViewModel {
    let title = "Home"
    
    
    enum SectionType {
        
        case category(viewModel: [CategoryViewCellViewModel])
        case recomend(viewModel: [RecomendViewCellViewModel])
        case oftheWeek(viewModel: [WeekViewCellViewModel])
    }
    public var sections: [SectionType] = []
    //MARK: - init
    init() {
       uploadRecipes()
    }
    
    //MARK: functions
    
    private func uploadRecipes() {
        self.sections = [
            .category(viewModel: [.init(category: CategoryModel(id: 1, name: "breakfast", image: "english-breakfast")),
                                  .init(category: CategoryModel(id: 2, name: "lunch", image: "lunch")),
                                  .init(category: CategoryModel(id: 3, name: "dinner", image: "christmas-dinner")),
                                  .init(category: CategoryModel(id: 4, name: "dissert", image: "panna-cotta")),
                                  .init(category: CategoryModel(id: 5, name: "snacks appetizers", image: "nachos")),
                                  .init(category: CategoryModel(id: 6, name: "salads", image: "salad")),
                                  .init(category: CategoryModel(id: 7, name: "soups stews", image: "goulash")),
                                  .init(category: CategoryModel(id: 8, name: "pasta noodles", image: "noodles")),
                                  .init(category: CategoryModel(id: 9, name: "grilling barbecue", image: "grilling")),
                                  .init(category: CategoryModel(id: 10, name: "vegetarian vegan", image: "vegetable"))]),
            .recomend(viewModel: [
                .init(recomendRecipe: RecipeModel(title: "Salat", category: "salads", description: "", ceator: "Mary", createdDate: Date(), image: "saladRecipe")),
                .init(recomendRecipe: RecipeModel(title: "Pancakes", category: "dinner", description: "", ceator: "Mary", createdDate: Date(), image: "pancakes")),
                .init(recomendRecipe: RecipeModel(title: "Asparagus", category: "dinner", description: "", ceator: "Mary", createdDate: Date(), image: "asparagus")),
            ]),
            .oftheWeek(viewModel: [
                .init(recomendRecipe: RecipeModel(title: "Salat", category: "salads", description: "", ceator: "Mary", createdDate: Date(), image: "saladRecipe")),
                .init(recomendRecipe: RecipeModel(title: "Pancakes", category: "dinner", description: "", ceator: "Mary", createdDate: Date(), image: "pancakes")),
                .init(recomendRecipe: RecipeModel(title: "Asparagus", category: "dinner", description: "", ceator: "Mary", createdDate: Date(), image: "asparagus")),
            ])
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
        section.orthogonalScrollingBehavior = .continuous
        
        // Create the header item and add it to the section
         let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
         let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         section.boundarySupplementaryItems = [headerItem]
        return section
    }
}
