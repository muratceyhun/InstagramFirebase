//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 29.08.2023.
//

import Foundation


struct Comment {
    let text: String
    let uid: String
    
    
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
