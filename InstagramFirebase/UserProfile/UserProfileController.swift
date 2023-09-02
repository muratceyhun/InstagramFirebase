//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }
    
    var isGridView = true
    var isFinishedPaging = false
    var posts = [Post]()
    var user: User?
    var userID: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
//        navigationItem.title = Auth.auth().currentUser?.uid
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "homeCellID")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleLogOut))
        fetchUser()
//        fetchedOrderedPosts()
    }
    
    fileprivate func paginatePost() {
        print("Start to paginate...")
        guard let uid = user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
//        let value = "-Nbyu92BZOYRgiYcY3sW"
//        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
        
        var query = ref.queryOrderedByKey()
        
        if posts.count > 0 {
            let value = posts.last?.id
            query = query.queryStarting(atValue: value)
        }
        
        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value) { snapshot in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else {return}
            
            allObjects.forEach({ snapshot in
                guard let dictionary = snapshot.value as?  [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
//                print(snapshot.key)
                
                self.posts.forEach { post in
                    print(post.id ?? "")
                }
            })
            
            self.collectionView.reloadData()
            
            
        } withCancel: { err in
            print("Failed to paginate", err)
        }

        
    }
    
    fileprivate func fetchedOrderedPosts() {
        guard let uid = user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { snapshot in
            print(snapshot.key, snapshot.value)
            
            guard let user = self.user else {return}
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let post = Post(user: user, dictionary: dictionary)
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
        header.delegate = self
        
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // fire off to the pagination
        
        if indexPath.item == posts.count - 1 && !isFinishedPaging {
            print("paginate for post")
            paginatePost()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCellID", for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8
            height += view.frame.width
            height += 50
            height += 60
            return .init(width: collectionView.frame.width, height: height)
        }
      
    }
    
    fileprivate func fetchUser() {
        let uid = userID ?? Auth.auth().currentUser?.uid ?? ""
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
//            self.fetchedOrderedPosts()
            self.paginatePost()
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}




