//
//  Post.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 15.08.2023.
//

import Foundation

struct Post {
    
    var id: String?
    
    let user: User
    let imageURL: String
    let caption: String
    let creationDate: Date
    
    var hasLiked: Bool = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        let seconsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: seconsFrom1970)
    }
}
