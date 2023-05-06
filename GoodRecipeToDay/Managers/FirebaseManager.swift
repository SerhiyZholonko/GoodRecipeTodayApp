//
//  FirebaseManager.swift
//  GoodRecipeToDay
//
//  Created by apple on 06.05.2023.
//

import Foundation
import Firebase

class FirebaseManager {
    
    
     static let shared = FirebaseManager() // Singleton instance
     
     private let auth = Auth.auth() // Firebase Auth instance
    private let ref = Database.database().reference() // Firebase Realtime Database reference

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
    
    func createTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let todoRef = ref.child("todos").childByAutoId() // Create a new child node with a unique ID
        todoRef.setValue(todo.toDictionary()) { error, ref in // Convert the todo to a dictionary and set it at the new node
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func readTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        ref.child("todos").observeSingleEvent(of: .value) { snapshot in
            var todos = [Todo]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let todo = Todo(snapshot: snapshot) {
                    todos.append(todo)
                }
            }
            completion(.success(todos))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let key = todo.key else {
            completion(.failure(FirebaseError.missingKey))
            return
        }
        ref.child("todos").child(key).setValue(todo.toDictionary()) { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let key = todo.key else {
            completion(.failure(FirebaseError.missingKey))
            return
        }
        ref.child("todos").child(key).removeValue { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        FirebaseApp.configure()
    }
    
}

struct Todo {
    let name: String
    let completed: Bool
    let key: String?
    
    init(name: String, completed: Bool, key: String? = nil) {
        self.name = name
        self.completed = completed
        self.key = key
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let name = dict["name"] as? String,
              let completed = dict["completed"] as? Bool else {
            return nil
        }
        self.name = name
        self.completed = completed
        self.key = snapshot.key
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [
            "name": name,
            "completed": completed
        ] as [String : Any]
        if let key = key {
            dict["key"] = key
        }
        return dict
    }
}

enum FirebaseError: Error {
    case missingKey
}
