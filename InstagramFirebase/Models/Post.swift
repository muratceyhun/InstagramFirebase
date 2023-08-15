//
//  Post.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 15.08.2023.
//

import Foundation

struct Post {
    let imageURL: String
    
    init(dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
