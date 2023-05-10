//
//  FirebaseManager.swift
//  GoodRecipeToDay
//
//  Created by apple on 06.05.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class FirebaseManager {
    
    
    static let shared = FirebaseManager() // Singleton instance
    
    private let auth = Auth.auth() // Firebase Auth instance
    //    private let ref = Database.database().reference() // Firebase Realtime Database reference
    private let ref = Database.database(url: "https://goodrecipetoday-1aeb8-default-rtdb.europe-west1.firebasedatabase.app").reference()
    private let storage = Storage.storage().reference()
    private let imageManager = FirebaseImageManager() // Instance of FirebaseImageManager
    private let database = Firestore.firestore()
    
   
    // MARK: - User management
    
    func currentUser() -> User? {
        return auth.currentUser
    }
    // MARK: - Todo management
    
    func createRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        let recipeRef = ref.child("recipes").childByAutoId() // Create a new child node with a unique ID
        recipeRef.setValue(recipe.toDictionary()) { error, ref in // Convert the todo to a dictionary and set it at the new node
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func readRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        ref.child("recipes").observeSingleEvent(of: .value) { snapshot in
            var recipes = [Recipe]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let recipe = Recipe(snapshot: snapshot) {
                    recipes.append(recipe)
                }
            }
            completion(.success(recipes))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    func updateRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let key = recipe.key else {
            completion(.failure(FirebaseError.missingKey))
            return
        }
        ref.child("recipes").child(key).setValue(recipe.toDictionary()) { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let key = recipe.key else {
            completion(.failure(FirebaseError.missingKey))
            return
        }
        ref.child("recipes").child(key).removeValue { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Initialization
    

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(FirebaseError.imageConversionFailure))
            return
        }
        guard let image = UIImage(data: imageData) else { return }

        imageManager.uploadImage(image) { result in
            switch result {
            case .success(let downloadURL):
                print(downloadURL.absoluteString)
                completion(.success(downloadURL.absoluteString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


extension FirebaseManager {
    // MARK: - Authentication
    func signIn(username: String, passsword: String, complition: @escaping (Bool) -> Void ) {
        database.collection("users").document(username).getDocument { [weak self] snapshot, error in
            guard let email = snapshot?.data()?["email"] as? String, error == nil else {
                return
            }
            self?.auth.signIn(withEmail: email, password: passsword) { result, error in
                guard result != nil, error == nil else {
                    complition(false)
                    return
                }
                complition(true)
        }
       
        }
    }
    func signUp(username: String, email: String, password: String, complition: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                complition(false)
                return
            }
            let data = [
                "email": email,
                "user": username,
            ]
            self.database.collection("users").document(username).setData(data) { error in
                guard error == nil else {complition(false)
                    return  }
            }
            complition(true)
        }
    }
     func signOut() {
         do {
             try Auth.auth().signOut()
             
         } catch {
             
         }
    }
}
enum FirebaseError: Error {
    case missingKey
    case imageConversionFailure
}
