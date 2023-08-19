//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 18.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "cellID")
        setupNavigationItems()
        fetchPosts()
    }
    
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            let user = User(dictionary: userDictionary)
            
            let ref = Database.database().reference().child("posts").child(uid)
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let dictionaries = snapshot.value as? [String: Any] else {return}
                dictionaries.forEach { key, value in
                    guard let dictionary = value as? [String: Any] else {return}
                    let post = Post(user: user, dictionary: dictionary)
                    self.posts.append(post)
                }
                
                self.collectionView.reloadData()
            } withCancel: { err in
                 print("ERROR", err)
            }
                
            print(snapshot.value)
        } withCancel: { err in
            print("Failed to fetch user for posts", err)
        }

      

    }
    

    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! HomeCell
        let post = self.posts[indexPath.item]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return .init(width: collectionView.frame.width, height: height)
    }
}
