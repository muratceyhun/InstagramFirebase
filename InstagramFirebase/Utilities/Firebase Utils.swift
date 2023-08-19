//
//  Firebase Utils.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 19.08.2023.
//

import Foundation

import FirebaseDatabase


extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping(User) -> ()) {
        print("Fetching user with UID", uid)
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}

            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
//            self.fetchPostsWithUser(user: user)

            print(snapshot.value)
        } withCancel: { err in
            print("Failed to fetch user for posts", err)
        }
    }
}
