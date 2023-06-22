//
//  User.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.05.2023.
//

//
import UIKit
import FirebaseFirestore

final class GUser: Hashable, Decodable, Equatable {
    var uid: String
    var email: String
    var username: String
    var urlString: String? = nil
    var followers: [GUser] = []
    let key: String?
    
    init(uid: String, email: String, username: String, urlString: String? = nil, followers: [GUser] = [],  key: String? = nil) {
        self.uid = uid
        self.email = email
        self.username = username
        self.urlString = urlString
        self.followers = followers
        self.key = key
    }
    
    init?(dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String,
            let uid = dictionary["uid"] as? String,
            let urlString = dictionary["urlString"] as? String,
            let key = dictionary["key"] as? String? else {
                return nil
        }
        
        self.username = username
        self.email = email
        self.uid = uid
        self.urlString = urlString
        self.key = key
    }
    
    init?(document: QueryDocumentSnapshot) {
        guard let username = document.data()["username"] as? String,
            let email = document.data()["email"] as? String,
            let uid = document.data()["uid"] as? String
        else {
            return nil
        }

        self.username = username
        self.email = email
        self.uid = uid

        if let urlString = document.data()["urlString"] as? String {
            self.urlString = urlString
        } else {
            self.urlString = ""
        }

        self.key = document.documentID

        // Initialize followers as an empty array
        if let followersData = document.data()["followers"] as? [[String: Any]] {
            self.followers = followersData.compactMap { GUser(dictionary: $0) }
        } else {
            self.followers = []
        }
    }


    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
            let username = data["username"] as? String,
            let email = data["email"] as? String,
            let uid = data["uid"] as? String,
            let urlString = data["urlString"] as? String
        else {
            return nil
        }

        self.username = username
        self.email = email
        self.uid = uid
        self.urlString = urlString
        self.key = document.documentID

        // Initialize followers as an empty array
        if let followersData = data["followers"] as? [[String: Any]] {
            self.followers = followersData.compactMap { GUser(dictionary: $0) }
        } else {
            self.followers = []
        }
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["username"] = username
        dictionary["email"] = email
        dictionary["uid"] = uid
        dictionary["urlString"] = urlString
        if let key = key {
            dictionary["key"] = key
        }
        return dictionary
    }

    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["uid"] = uid
        rep["urlString"] = urlString
        if let key = key {
            rep["key"] = key
        }
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: GUser, rhs: GUser) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return username.lowercased().contains(lowercasedFilter)
    }
}


