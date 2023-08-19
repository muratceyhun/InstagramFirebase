//
//  User.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 19.08.2023.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageURL: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profilePhotoURL"] as? String ?? ""
        self.uid = uid
    }
    
}
