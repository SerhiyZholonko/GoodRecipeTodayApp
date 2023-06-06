//
//  User.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.05.2023.
//
import UIKit
import FirebaseFirestore



final class GUser: Hashable, Decodable {
    var uid: String
    var email: String
    var username: String
    var urlString: String? = nil
    
    init(uid: String, email: String, username: String, urlString: String? = nil) {
        self.uid = uid
        self.email = email
        self.username = username
        self.urlString = urlString
    }
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let uid = data["uid"] as? String,
        let urlString = data["urlString"] as? String else { return nil }

        self.username = username
        self.email = email
        self.uid = uid
        self.urlString = urlString
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let uid = data["uid"] as? String,
        let urlString = data["urlString"] as? String else { return nil }

        self.username = username
        self.email = email
        self.uid = uid
        self.urlString = urlString

    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["uid"] = uid
        rep["urlString"] = urlString
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

