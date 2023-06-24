//
//  RecomendViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 10.06.2023.
//

import Foundation
import FirebaseFirestore


protocol RecomendViewControllerViewModelDelegate: AnyObject {

    func didFetchData()
    func didFail(with error: Error)
}

final class RecomendViewControllerViewModel {
    //MARK: - Properties
     weak var delegate: RecomendViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    let title = "Redomend"
    
    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false
    
    private(set) var dataSource: [Recipe] = []

    //MARK: - Init
    init() {
    }
    //MARK: - Functions
    public func getRecipe(indexParh: IndexPath) -> Recipe {
        return dataSource[indexParh.item]
    }
    public func getRecipesCount() -> Int {
        return dataSource.count
    }
    func fetchFirstPage() {
        guard !isFetchingData else {
            return
        }
        
        isFetchingData = true
        
        fetchRecipes(pageSize: pageSize, lastSnapshot: nil) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetchingData = false
            
            switch result {
            case .success(let (recipes, nextSnapshot)):
                self.dataSource = recipes
                self.lastSnapshot = nextSnapshot
                self.delegate?.didFetchData()
                
            case .failure(let error):
                self.delegate?.didFail(with: error)
            }
        }
    }
    func fetchNextPage() {
        guard !isFetchingData, let lastSnapshot = lastSnapshot else {
            return
        }
        
        isFetchingData = true
        
        fetchRecipes(pageSize: pageSize, lastSnapshot: lastSnapshot) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetchingData = false
            
            switch result {
            case .success(let (recipes, nextSnapshot)):
                self.dataSource.append(contentsOf: recipes)
                self.lastSnapshot = nextSnapshot
                self.delegate?.didFetchData()
                
            case .failure(let error):
                self.delegate?.didFail(with: error)
            }
        }
    }
    
    func startListeningForChanges() {
        // Implement your snapshot listener logic here if needed
    }
    
    func stopListeningForChanges() {
        // Implement your snapshot listener logic here if needed
    }
    
    private func fetchRecipes(pageSize: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<([Recipe], DocumentSnapshot?), Error>) -> Void) {
        firebaseManager.fetchRecipes(pageSize: pageSize, lastSnapshot: lastSnapshot) {  result in
            
            switch result {
            case .success(let snapshot):
                var recipes: [Recipe] = []
                var nextSnapshot: DocumentSnapshot?
                
                for recipeDocument in snapshot.documents {
                    if let recipe = Recipe(snapshot: recipeDocument) {
                            recipes.append(recipe)
                    }
                }
                
                if let lastDocumentSnapshot = snapshot.documents.last {
                    nextSnapshot = lastDocumentSnapshot
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Introduce a 2-second delay (adjust the delay time as needed)
                    completion(.success((recipes, nextSnapshot)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
