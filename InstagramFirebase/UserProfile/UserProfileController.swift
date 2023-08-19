//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var posts = [Post]()
    var user: User?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "cellID")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleLogOut))
        
        fetchedOrderedPosts()
    }
    
    fileprivate func fetchedOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { snapshot in
            print(snapshot.key, snapshot.value)
            
            guard let user = self.user else {return}
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let post = Post(user: user, dictionary: dictionary )
            self.posts.insert(post, at: 0)
//            self.posts.append(post)
            self.collectionView.reloadData()
            
        } withCancel: { err in
            print("Failed to get posts orderly", err)
        }

    }
    

    
    @objc fileprivate func handleLogOut() {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        present(alertController, animated: true)
        let alertAction1 = UIAlertAction(title: "Log out", style: .destructive) { _ in
            print("Log Out")
            do {
                try Auth.auth().signOut()
                let logInController = LoginViewController()
                let navController = UINavigationController(rootViewController: logInController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)

            } catch let err {
                print("ERROR", err)
            }
        }
        let alertAction2 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
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




