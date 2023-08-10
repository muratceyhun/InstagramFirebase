//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    var user: User?
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            print(snapshot.value ?? "")
        } withCancel: { err in
            print("Failed to fetch user", err)
        }
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}



struct User {
    let username: String
    let profileImageURL: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profilePhotoURLL"] as? String ?? ""
    }
    
}

