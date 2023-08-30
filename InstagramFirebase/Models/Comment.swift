//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 29.08.2023.
//

import Foundation


struct Comment {
    let user: User
    let text: String
    let uid: String
    
    
    
    init(user: User,  dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
