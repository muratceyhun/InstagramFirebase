//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .gray
//        navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
    }
    
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observe(.value) { snapshot in
            
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?["username"] as? String
            self.navigationItem.title = username
            
            print(snapshot.value ?? "")
        } withCancel: { err in
            print("Failed to fetch user", err)
        }

        }
        
    }

