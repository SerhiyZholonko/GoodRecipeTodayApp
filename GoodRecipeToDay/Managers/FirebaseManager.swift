//
//  FirebaseManager.swift
//  GoodRecipeToDay
//
//  Created by apple on 06.05.2023.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
    
    
    static let shared = FirebaseManager() // Singleton instance
    
    private let auth = Auth.auth() // Firebase Auth instance
    //    private let ref = Database.database().reference() // Firebase Realtime Database reference
    private let ref = Database.database(url: "https://goodrecipetoday-1aeb8-default-rtdb.europe-west1.firebasedatabase.app").reference()
    private let storage = Storage.storage().reference()
    private let imageManager = FirebaseImageManager() // Instance of FirebaseImageManager

    // MARK: - Authentication
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signup(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func logout() {
        do {
            try auth.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
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
struct Recipe {
    let mainImage: String
    let title: String
    let description: String
    let category: String
    let quantity: String
    let time: String
    let key: String?
    let steps: [Step]
    let ingredients: [Ingredient]
    
    init(mainImage: String, title: String, description: String, category: String, quantity: String, time: String, steps: [Step], ingredients: [Ingredient], key: String? = nil) {
        self.mainImage = mainImage
        self.title = title
        self.description = description
        self.category = category
        self.quantity = quantity
        self.time = time
        self.steps = steps
        self.ingredients = ingredients
        self.key = key
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let mainImage = dict["mainImage"] as? String,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let category = dict["category"] as? String,
              let quantity = dict["quantity"] as? String,
              let time = dict["time"] as? String,
              let stepsDict = dict["steps"] as? [[String: Any]],
              let ingredientsDict = dict["ingredients"] as? [[String: Any]] else {
                  return nil
              }
        
        var steps: [Step] = []
        for stepDict in stepsDict {
            if let step = Step(dict: stepDict) {
                steps.append(step)
            }
        }
        
        var ingredients: [Ingredient] = []
        for ingredientDict in ingredientsDict {
            if let ingredient = Ingredient(dict: ingredientDict) {
                ingredients.append(ingredient)
            }
        }
        
        self.mainImage = mainImage
        self.title = title
        self.description = description
        self.category = category
        self.quantity = quantity
        self.time = time
        self.steps = steps
        self.ingredients = ingredients
        self.key = snapshot.key
    }
    
    func toDictionary() -> [String: Any] {
        var stepsDict: [[String: Any]] = []
        for step in steps {
            stepsDict.append(step.toDictionary())
        }
        
        var ingredientsDict: [[String: Any]] = []
        for ingredient in ingredients {
            ingredientsDict.append(ingredient.toDictionary())
        }
        
        var dict = [
            "mainImage": mainImage,
            "title": title,
            "description": description,
            "category": category,
            "quantity": quantity,
            "time": time,
            "steps": stepsDict,
            "ingredients": ingredientsDict
        ] as [String : Any]
        if let key = key {
            dict["key"] = key
        }
        return dict
    }
}


struct Ingredient {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    init?(dict: [String: Any]) {
        guard let title = dict["title"] as? String else {
            return nil
        }
        self.title = title
    }
    
    func toDictionary() -> [String: Any] {
        return ["title": title]
    }
}
struct Step {
    let title: String
    var imageUrl: String?
    
    init(title: String, imageUrl: String?) {
        self.title = title
        self.imageUrl = imageUrl
    }
    
    init?(dict: [String: Any]) {
        guard let title = dict["title"] as? String else {
            return nil
        }
        
        self.title = title
        self.imageUrl = dict["imageUrl"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["title": title]
        
        if let imageUrl = imageUrl {
            dict["imageUrl"] = imageUrl
        }
        
        return dict
    }
    
    mutating func setImage(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseImageManager.shared.uploadImage(image) { [self] result in
            var mutableSelf = self
            switch result {
            case .success(let url):
                mutableSelf.imageUrl = url.absoluteString
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            FirebaseImageManager.shared.downloadImage(from: url) { result in
                switch result {
                case .success(let image):
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(nil))
        }
    }
    
    func deleteImage(completion: @escaping (Result<Void, Error>) -> Void) {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            FirebaseImageManager.shared.deleteImage(at: url) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(()))
        }
    }
}
enum FirebaseError: Error {
    case missingKey
    case imageConversionFailure
}
