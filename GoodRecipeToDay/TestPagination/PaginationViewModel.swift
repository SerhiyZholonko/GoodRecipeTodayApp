//
//  File.swift
//  GoodRecipeToDay
//
//  Created by apple on 13.06.2023.
//

import UIKit
import FirebaseFirestore

protocol PaginationViewModelDelegate: AnyObject {
    func didFetchData()
    func didFail(with error: Error)
}

class PaginationViewModel {
    
    let firebaseManager = FBManager.shared
    
//    private let database = Firestore.firestore()
    private let pageSize: Int = 10
    private var lastSnapshot: DocumentSnapshot?
    private var isFetchingData: Bool = false
//    private var listener: ListenerRegistration?
    
    private(set) var dataSource: [Recipe] = []
    weak var delegate: PaginationViewModelDelegate?
    
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
        FBManager.shared.getAllMainRecipes(pageSize: pageSize, lastSnapshot: lastSnapshot) {  result in
            
            switch result {
            case .success(let snapshot):
                var recipes: [Recipe] = []
                var nextSnapshot: DocumentSnapshot?
                
                for recipeDocument in snapshot.documents {
                    if let recipe = Recipe(snapshot: recipeDocument) {
                        print("user name name: ", recipe.username)
                        print("recipe title: ", recipe.title)
                        recipes.append(recipe)
                    }
                }
                
                if let lastDocumentSnapshot = snapshot.documents.last {
                    nextSnapshot = lastDocumentSnapshot
                }
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // Introduce a 2-second delay (adjust the delay time as needed)
                print(recipes.count)
                    completion(.success((recipes, nextSnapshot)))
//                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }}
