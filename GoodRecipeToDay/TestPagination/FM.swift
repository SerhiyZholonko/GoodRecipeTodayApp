//
//  FM.swift
//  GoodRecipeToDay
//
//  Created by apple on 14.06.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
class FBManager {
    static let shared = FBManager() // Singleton instance
    private let database = Firestore.firestore()

    var usersnames: [String] = [] {
        didSet {
            print(usersnames.self)
        }
    }
    
    init() {
        
    }
    private func setUsernames(completion: @escaping ([GUser]) -> Void) {
        getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
//                let usernames = users.map { $0.username }
                completion(users)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }

    //pagination
    
        func getAllUsers(completion: @escaping (Result<[GUser], Error>) -> Void) {
            let recipesCollectionRef = database.collection("users")
            
            recipesCollectionRef.getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                var usersnames: [GUser] = []
                for document in querySnapshot!.documents {
                     let followerData = document.data()
                    if let username = GUser(dictionary: followerData) {
                        usersnames.append(username)
                    }
                }
                completion(.success(usersnames))
                return
            }
        }

    
    
    func  fetchAllUsersRecipes(pageSize: Int, username: String, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        let recipesCollection =
        database.collection("users").document(username).collection("recipes")
        var query = recipesCollection.limit(to: pageSize)
        
        if let lastSnapshot = lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let snapshot = snapshot {
                completion(.success(snapshot))
            } else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data from Firestore"])))
            }
        }
    }
    func fetchRecipes(pageSize: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        setUsernames { users in
            for user in users {
                print(user.username)
                self.fetchAllUsersRecipes(pageSize: 10, username: user.username, lastSnapshot: lastSnapshot, completion: completion)
            }
        }
       
    }
    func getAllMainRecipes(pageSize: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        let recipesCollectionRef = database.collection("users")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            for document in querySnapshot!.documents {
                 let data = document.data()
                if let user = GUser(dictionary: data) {
                    print("user: ", user.username)
                    let recipesCollection =
                    self.database.collection("users").document(user.username).collection("recipes")
                    var query = recipesCollection.limit(to: pageSize)
                    
                    if let lastSnapshot = lastSnapshot {
                        query = query.start(afterDocument: lastSnapshot)
                    }
                    
                    query.getDocuments { snapshot, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        if let snapshot = snapshot {
                            completion(.success(snapshot))
                        } else {
                            completion(.failure(NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch data from Firestore"])))
                        }
                    }
                }
            }
            return
        }
    }
    
}
