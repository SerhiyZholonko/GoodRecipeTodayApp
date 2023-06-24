////
////  Recipe.swift
////  GoodRecipeToDay
////
////  Created by apple on 10.05.2023.
////

import UIKit
import Firebase


struct Recipe: Hashable, Equatable {
 
    
    let mainImage: String
    let title: String
    let description: String
    let category: String
    let quantity: String
    let time: String
    let key: String? 
    var rate: Double? = nil
    var rateCounter: Int = 0
    let steps: [Step]
    let ingredients: [Ingredient]
    var chats: [Chat] = []
    let username: String
    let createdAt: Timestamp?


    init(mainImage: String, title: String, description: String, category: String, quantity: String, time: String, steps: [Step], ingredients: [Ingredient], chats: [Chat] = [], key: String? = nil, username: String, createdAt: Timestamp? = nil) {
        self.mainImage = mainImage
        self.title = title
        self.description = description
        self.category = category
        self.quantity = quantity
        self.time = time
        self.steps = steps
        self.ingredients = ingredients
        self.chats = chats
        self.key = key
        self.username = username
        self.createdAt = createdAt
    }
    
    
    init?(documentSnapshot: DocumentSnapshot) {
           guard let data = documentSnapshot.data(),
                 let mainImage = data["mainImage"] as? String,
                 let title = data["title"] as? String,
                 let description = data["description"] as? String,
                 let category = data["category"] as? String,
                 let quantity = data["quantity"] as? String,
                 let time = data["time"] as? String,
                 let steps = data["steps"] as? [Step],
                 let ingredients = data["ingredients"] as? [Ingredient],
                 let chats = data["chat"] as? [Chat],
                 let username = data["username"] as? String else {
               return nil
           }
           
           self.mainImage = mainImage
           self.title = title
           self.description = description
           self.category = category
           self.quantity = quantity
           self.time = time
           self.key = data["key"] as? String
           self.rate = data["rate"] as? Double
           self.rateCounter = data["rateCounter"] as? Int ?? 0
           self.steps = steps
           self.ingredients = ingredients
        self.chats = chats
           self.username = username
           self.createdAt = data["createdAt"] as? Timestamp
       }
    init?(snapshot: Any?) {
        guard let dict = snapshot as? [String: Any],
            let mainImage = dict["mainImage"] as? String,
            let title = dict["title"] as? String,
            let description = dict["description"] as? String,
            let category = dict["category"] as? String,
            let quantity = dict["quantity"] as? String,
            let time = dict["time"] as? String,
            let stepsDict = dict["steps"] as? [[String: Any]],
            let ingredientsDict = dict["ingredients"] as? [[String: Any]],
//            let chatsDict = dict["chat"] as? [[String: Any]],
            let rateDict = dict["rate"] as? Double?,
            let rateCounterDict = dict["rateCounter"] as? Int?, // Retrieve rateCounter
            let usernameDict = dict["username"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp
            else {
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
//        var chats: [Chat] = []
//        for chatDict in chatsDict {
//            if let chat = Chat(dict: chatDict) {
//                chats.append(chat)
//            }
//        }
        self.mainImage = mainImage
        self.title = title
        self.description = description
        self.category = category
        self.quantity = quantity
        self.time = time
        self.steps = steps
        self.ingredients = ingredients
//        self.chats = chats
        self.rate = rateDict
        self.rateCounter = rateCounterDict ?? 0 // Assign rateCounter
        self.key = (snapshot as AnyObject).key
        self.username = usernameDict
        self.createdAt = createdAt
    }
    init?(snapshot: QueryDocumentSnapshot) {
        let dict = snapshot.data()
        guard
            let mainImage = dict["mainImage"] as? String,
            let title = dict["title"] as? String,
            let description = dict["description"] as? String,
            let category = dict["category"] as? String,
            let quantity = dict["quantity"] as? String,
            let time = dict["time"] as? String,
            let stepsDict = dict["steps"] as? [[String: Any]],
            let ingredientsDict = dict["ingredients"] as? [[String: Any]],
//            let chatsDict = dict["chat"] as? [[String: Any]],
            let rateDict = dict["rate"] as? Double?,
            let rateCounterDict = dict["rateCounter"] as? Int?, // Retrieve rateCounter
            let usernameDict = dict["username"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp
        else {
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
//        var chats: [Chat] = []
//        for chatDict in chatsDict {
//            if let chat = Chat(dict: chatDict) {
//                chats.append(chat)
//            }
//        }
        self.mainImage = mainImage
        self.title = title
        self.description = description
        self.category = category
        self.quantity = quantity
        self.time = time
        self.steps = steps
        self.ingredients = ingredients
//        self.chats = chats
        self.key = snapshot.documentID
        self.rate = rateDict
        self.rateCounter = rateCounterDict ?? 0 // Assign rateCounter
        self.username = usernameDict
        self.createdAt = createdAt
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
            "ingredients": ingredientsDict,
            "chat": chats,
            "createdAt": createdAt ?? FieldValue.serverTimestamp(),
            "rate": rate ?? 0.0,
            "rateCounter": NSNumber(value: rateCounter) // Convert rateCounter to NSNumber

        ] as [String : Any]
        if let key = key {
            dict["key"] = key
        }
        return dict
    }
    //MARK: - Functions
    mutating func incrementRateCounter() {
           rateCounter += 1
       }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mainImage)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(category)
        hasher.combine(quantity)
        hasher.combine(time)
        hasher.combine(steps)
        hasher.combine(ingredients)
        hasher.combine(chats)
        hasher.combine(username)
        hasher.combine(createdAt)
    }

    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.mainImage == rhs.mainImage &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.category == rhs.category &&
            lhs.quantity == rhs.quantity &&
            lhs.time == rhs.time &&
            lhs.steps == rhs.steps &&
            lhs.ingredients == rhs.ingredients &&
            lhs.chats == rhs.chats &&
            lhs.username == rhs.username &&
            lhs.createdAt == rhs.createdAt
    }

}


struct Ingredient: Hashable {
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
    
    func hash(into hasher: inout Hasher) {
          hasher.combine(title)
      }

      static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
          return lhs.title == rhs.title
      }
}

struct Chat: Hashable {
    let title: String
    let createdAt: Timestamp?
    let username: String?

    init(title: String, createdAt: Timestamp? = nil, username: String) {
        self.title = title
        self.createdAt = createdAt
        self.username = username
    }

    init?(dict: [String: Any]) {
        guard let title = dict["chat"] as? String else {
            return nil
        }
        guard let username = dict["username"] as? String else {
            return nil
        }
        self.title = title
        self.createdAt = dict["createdAt"] as? Timestamp
        self.username = username
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "chat": title,
            "username": username
        ]

        if let createdAt = createdAt {
            dictionary["createdAt"] = createdAt
        }

//        if let username = username {
//            dictionary["username"] = username
//        }

        return dictionary
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(username)
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.title == rhs.title && lhs.createdAt == rhs.createdAt && lhs.username == rhs.username
    }
}

struct Step: Hashable{
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
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(imageUrl)
    }

    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.title == rhs.title &&
            lhs.imageUrl == rhs.imageUrl
    }
}
