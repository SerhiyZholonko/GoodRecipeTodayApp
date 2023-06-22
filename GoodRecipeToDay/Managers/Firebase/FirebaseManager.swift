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
    private let storage = Storage.storage().reference()
    private let imageManager = FirebaseImageManager() // Instance of FirebaseImageManager
    private let database = Firestore.firestore()
    
    public var isUser = Auth.auth().currentUser == nil
    
    let db = Firestore.firestore()

    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    var mainUser: GUser? {
        didSet {
            
        }
    }
    func curenUser() -> Firebase.User? {
        return auth.currentUser
    }
  
    func createRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {

        var recipeData = recipe.toDictionary()
        recipeData["createdAt"] = Timestamp()
        database.collection("recipes").addDocument(data: recipeData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func readRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        database.collection("recipes").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var recipes = [Recipe]()
            for document in snapshot?.documents ?? [] {
                if let recipe = Recipe(snapshot: document) {
                    recipes.append(recipe)
                }
            }
            completion(.success(recipes))
        }
    }
    func readRecipes(forUserWithUID uid: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let recipesRef = database.collection("recipes")
        let query = recipesRef.whereField("uid", isEqualTo: uid)
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var recipes = [Recipe]()
            for document in snapshot?.documents ?? [] {
                if let recipe = Recipe(snapshot: document) {
                    recipes.append(recipe)
                }
            }
            completion(.success(recipes))
        }
    }
    func updateRecipe(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let key = recipe.key else {
            completion(.failure(FirebaseError.missingKey))
            return
        }
        var recipeData = recipe.toDictionary()
        recipeData["updatedAt"] = Timestamp()
        database.collection("recipes").document(key).setData(recipeData) { error in
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
        database.collection("recipes").document(key).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //pagination
    func fetchRecipes(pageSize: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        let recipesCollection = database.collection("recipes")
        
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

    
    func deleteFollower(_ follower: GUser, completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                self?.database.collection("users").document(username).collection("followers").document(follower.username).delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func deleteFollowing(_ follower: GUser, completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                self?.database.collection("users").document(follower.username).collection("followings").document(username).delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
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
    func getMainUserFromUsername(username: String, completion: @escaping (Result<GUser, Error>) -> Void) {
        let recipesCollectionRef = database.collection("users")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var users: [GUser] = []
            for document in querySnapshot!.documents {
                 let followerData = document.data()
                if let user = GUser(dictionary: followerData) {
                    users.append(user)
                }
            }
            for user in users {
                if user.username == username {
                    completion(.success(user))
                    return
                }
            }
        }
    }
    func getUserFromUsername(username: String, completion: @escaping (Result<GUser, Error>) -> Void) {
        let recipesCollectionRef = database.collection("users").document(username).collection("followers")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var users: [GUser] = []
            for document in querySnapshot!.documents {
                 let followerData = document.data()
                if let user = GUser(dictionary: followerData) {
                    users.append(user)
                }
            }
            for user in users {
                if user.username == username {
                    completion(.success(user))
                    return
                }
            }
        }
    }
    func getCurrentUsername(completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = auth.currentUser else {
            completion(.failure(FirebaseError.userNotLoggedIn))
            return
        }
        
        let usersRef = database.collection("users")
        let query = usersRef.whereField("uid", isEqualTo: currentUser.uid)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first, let username = document.data()["username"] as? String else {
                completion(.failure(FirebaseError.userNotLoggedIn))
                return
            }
            
            completion(.success(username))
        }
    }
    func addRecipeToUser(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                var recipeData = recipe.toDictionary()
                recipeData["createdAt"] = Timestamp()
                recipeData["username"] = username
                
                self?.database.collection("users").document(username).collection("recipes").addDocument(data: recipeData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func addRecipeToMainPath(_ recipe: Recipe, completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                var recipeData = recipe.toDictionary()
                recipeData["createdAt"] = Timestamp()
                recipeData["username"] = username
                
                self?.database.collection("recipes").addDocument(data: recipeData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    func addFollowToUser(_ user: GUser,  completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                let userData = user.toDictionary()
                self?.database.collection("users").document(username).collection("followers").document(user.username).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addFollowingToUser(_ user: GUser,  completion: @escaping (Result<Void, Error>) -> Void) {
        getCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                //
                self?.getMainUserFromUsername(username: username) { result in
                    switch result {
                        
                    case .success(let currentUser):
                        let userData = currentUser.toDictionary()
                        self?.database.collection("users").document(user.username).collection("followings").document(username).setData(userData) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
               
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecipeForUser(username: String, key: String, completion: @escaping (Result<Recipe?, Error>) -> Void) {
        let recipeDocumentRef = database.collection("users").document(username).collection("recipes").document(key)
        
        recipeDocumentRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documentData = document?.data() else {
                completion(.success(nil))
                return
            }
            
            let recipe = Recipe(snapshot: documentData)
            completion(.success(recipe))
        }
    }
    func getAllRecipesForUser(username: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let recipesCollectionRef = database.collection("users").document(username).collection("recipes")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var recipes: [Recipe] = []
            
            for document in querySnapshot!.documents {
                 let recipeData = document.data()
                    if let recipe = Recipe(snapshot: recipeData) {
                        recipes.append(recipe)
                    
                }
            }
            
            completion(.success(recipes))
        }
    }
    func getAllFollowing(username: String, completion: @escaping (Result<[GUser], Error>) -> Void) {
        let recipesCollectionRef = database.collection("users").document(username).collection("followings")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var followers: [GUser] = []
            for document in querySnapshot!.documents {
                 let followerData = document.data()
                if let follower = GUser(dictionary: followerData) {
                    followers.append(follower)
                }
            }
            completion(.success(followers))
            return
        }
    }
    func getAllFollowersForUser(username: String, completion: @escaping (Result<[GUser], Error>) -> Void) {
        let recipesCollectionRef = database.collection("users").document(username).collection("followers")
        
        recipesCollectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var followers: [GUser] = []
            for document in querySnapshot!.documents {
                 let followerData = document.data()
                if let follower = GUser(dictionary: followerData) {
                    followers.append(follower)
                }
            }
            completion(.success(followers))
            return
            
        }
    }


    func getRecipeIDForUser(username: String, recipeName: String , completion: @escaping (Result<String, Error>) -> Void) {
        let recipesCollectionRef = database.collection("users").document(username).collection("recipes")
        let query = recipesCollectionRef.whereField("title", isEqualTo: recipeName).limit(to: 1)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Recipe not found"])))
                return
            }
            
            let recipeID = document.documentID
            completion(.success(recipeID))
        }
    }
    func getRecipeIDForUserMain(recipeName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let recipesCollectionRef = database.collection("recipes")
        let query = recipesCollectionRef.whereField("title", isEqualTo: recipeName).limit(to: 1)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Recipe not found"])))
                return
            }
            
            let recipeID = document.documentID
            completion(.success(recipeID))
        }
    }
    func updateRecipeForUser(username: String, recipeID: String, newRate: Double, recipe: Recipe, completion: @escaping (Error?) -> Void) {
        let recipeDocumentRef = database.collection("users").document(username).collection("recipes").document(recipeID)

        let oldRate = recipe.rate ?? 0.0
        let rate = oldRate + newRate
        recipeDocumentRef.updateData(["rate": rate]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
        let newRateCounter = recipe.rateCounter + 1


        recipeDocumentRef.updateData(["rateCounter": newRateCounter]) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        
    }
    func updateRecipeMainForChat(username: String, recipeID: String, chatMessage: String, recipe: Recipe, completion: @escaping (Error?) -> Void) {
        let recipeDocumentRef = database.collection("recipes").document(recipeID)

        recipeDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var existingChats = document.data()?["chats"] as? [[String: Any]] {
                    // If "chats" field exists, update the array
                    let newChat = Chat(title: chatMessage, createdAt: Timestamp(date: Date()))
                    existingChats.append(newChat.toDictionary())

                    recipeDocumentRef.updateData(["chats": existingChats]) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    // If "chats" field doesn't exist, create a new array
                    let newChat = Chat(title: chatMessage, createdAt: Timestamp(date: Date()))

                    let newData = ["chats": [newChat.toDictionary()]]

                    recipeDocumentRef.updateData(newData) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            } else {
                completion(error)
            }
        }
    }
    func updateRecipeForChat(username: String, recipeID: String, chatMessage: String, recipe: Recipe, completion: @escaping (Error?) -> Void) {
        let recipeDocumentRef = database.collection("users").document(username).collection("recipes").document(recipeID)

        recipeDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var existingChats = document.data()?["chats"] as? [[String: Any]] {
                    // If "chats" field exists, update the array
                    let newChat = Chat(title: chatMessage, createdAt: Timestamp(date: Date()))
                    existingChats.append(newChat.toDictionary())

                    recipeDocumentRef.updateData(["chats": existingChats]) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    // If "chats" field doesn't exist, create a new array
                    let newChat = Chat(title: chatMessage, createdAt: Timestamp(date: Date()))

                    let newData = ["chats": [newChat.toDictionary()]]

                    recipeDocumentRef.updateData(newData) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            } else {
                completion(error)
            }
        }
    }
    func getChatsMainForRecipe(username: String, recipeID: String, completion: @escaping ([Chat]?, Error?) -> Void) {
        let recipeDocumentRef = database.collection("recipes").document(recipeID)

        recipeDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let chatsData = document.data()?["chats"] as? [[String: Any]] {
                    // Convert the dictionary data to an array of Chat objects
                    let chats = chatsData.compactMap { Chat(dict: $0) }
                    completion(chats, nil)
                } else {
                    // No chats found
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    func getChatsForRecipe(username: String, recipeID: String, completion: @escaping ([Chat]?, Error?) -> Void) {
        let recipeDocumentRef = database.collection("users").document(username).collection("recipes").document(recipeID)

        recipeDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let chatsData = document.data()?["chats"] as? [[String: Any]] {
                    // Convert the dictionary data to an array of Chat objects
                    let chats = chatsData.compactMap { Chat(dict: $0) }
                    completion(chats, nil)
                } else {
                    // No chats found
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    func updateRecipeMain(recipeID: String, newRate: Double, recipe: Recipe, completion: @escaping (Error?) -> Void) {
        let recipeDocumentRef = database.collection("recipes").document(recipeID)
        
        let oldRate = recipe.rate ?? 0.0
        let rate = oldRate + newRate
        let newRateCounter = recipe.rateCounter + 1
        
        let data: [String: Any] = [
            "rate": rate,
            "rateCounter": newRateCounter
        ]
        
        recipeDocumentRef.updateData(data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func updateImageUrlForUser(username: String, urlString: String, completion: @escaping (Error?) -> Void) {
        let recipeDocumentRef = database.collection("users").document(username)
        let urlString = urlString
        recipeDocumentRef.updateData(["urlString": urlString]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
        
    }
    func getAllPaginationRecipes(pageSize: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Result<([Recipe], DocumentSnapshot?), Error>) -> Void) {
        let usersCollection = database.collection("users")
        
        var query = usersCollection.limit(to: pageSize)
        
        if let lastSnapshot = lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var recipes = [Recipe]()
            var nextSnapshot: DocumentSnapshot?
            
            for document in snapshot?.documents ?? [] {
                let userDocRef = document.reference
                let recipesCollection = userDocRef.collection("recipes")
                
                recipesCollection.getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    for document in snapshot?.documents ?? [] {
                        if let recipe = Recipe(snapshot: document) {
                            recipes.append(recipe)
                        }
                    }
                    
                    if let lastDocumentSnapshot = snapshot?.documents.last {
                        nextSnapshot = lastDocumentSnapshot
                    }
                    
                    completion(.success((recipes, nextSnapshot)))
                }
            }
        }
    }
    func getAllRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let usersCollection = database.collection("users")
        usersCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var recipes = [Recipe]()
            for document in snapshot?.documents ?? [] {
                let userDocRef = document.reference
                let recipesCollection = userDocRef.collection("recipes")
                
                recipesCollection.getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    for document in snapshot?.documents ?? [] {
                        if let recipe = Recipe(snapshot: document) {
                            recipes.append(recipe)
                        }
                    }
                    completion(.success(recipes))
                }
            }
        }
    }
   
    func getAllRecipesForUser(user: GUser, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var recipes = [Recipe]()
        let usersCollection = database.collection("users")
        usersCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in snapshot?.documents ?? [] {
                let userDocRef = document.reference
                let recipesCollection = userDocRef.collection("recipes")
                
                recipesCollection.getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    for document in snapshot?.documents ?? [] {
                        if let recipe = Recipe(snapshot: document) {
                            if recipe.username == user.username {
                                recipes.append(recipe)
                            }
                        }
                    }
                    
                    completion(.success(recipes))
                }
            }
        }
    }
    func fetchCurrentUser(completion: @escaping (GUser?) -> Void) {
        getAllUsers { users, error in
            guard let users = users else {
                print("No users")
                completion(nil)
                return
            }
            print(users.count)

            guard let currentUser = Auth.auth().currentUser else {
                print("No current user")
                completion(nil)
                return
            }
            print(currentUser.uid)
            print(users.count)
            let uid = currentUser.uid
            for user in users {
                if user.uid == uid {
                    self.mainUser = user
                    completion(user)
                    return
                }
            }
            // If we get here, it means we didn't find a matching user
            print("No user found")
            completion(nil)
        }
    }


    func getAllUsers(completion: @escaping ([GUser]?, Error?) -> Void) {
        database.collection("users").getDocuments { snapshot, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            var users: [GUser] = []
            
            for document in snapshot!.documents {
                if let user = GUser(document: document) {
                    users.append(user)
                }
            }
            completion(users, nil)
        }
    }


}



extension FirebaseManager {
    // MARK: - Authentication
        func signIn(username: String, password: String, completion: @escaping (Error?) -> Void) {
            database.collection("users").document(username).getDocument { [weak self] snapshot, error in
                guard let email = snapshot?.data()?["email"] as? String, let _ = snapshot?.data()?["uid"] as? String, error == nil else {
                    return
                }
                self?.auth.signIn(withEmail: email, password: password) { result, error in
                    guard result != nil, error == nil else {
                        completion(error)
                        return
                    }
//                    let user = GUser(uid: uid, email: email, username: username)
//                    self?.currentUser = user
                    completion(nil)
                }
            }
        }
        
        func signUp(username: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
            auth.createUser(withEmail: email, password: password) { result, error in
                guard let uid = result?.user.uid, error == nil else {
                    completion(error)
                    return
                }
                let data = [
                    "email": email,
                    "username": username,
                    "uid": uid
                ]
                self.database.collection("users").document(username).setData(data) { error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
//                    let user = GUser(uid: uid, email: email, username: username)

                    completion(nil)
                }
            }
        }
    func signUpInGoogle(username: String, email: String, uid: String, completion: @escaping (Error?) -> Void) {
          
            let data = [
                "email": email,
                "username": username,
                "uid": uid
            ]
            self.database.collection("users").document(username).setData(data) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
//                    let user = GUser(uid: uid, email: email, username: username)

                completion(nil)
            }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
enum FirebaseError: Error {
    case missingKey
    case imageConversionFailure
    case userNotLoggedIn
}


enum UserError: Error {
    case cannotUnwrapToUser
    case cannotGetUserInfo
}
