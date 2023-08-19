//
//  Post.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 15.08.2023.
//

import Foundation

struct Post {
    
    let user: User
    let imageURL: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
