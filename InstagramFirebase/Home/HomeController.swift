//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 18.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase





class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostDelegate {
    
    var posts = [Post]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "cellID")
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
        setupNavigationItems()
        fetchAllPosts()
       
    }
    
    @objc fileprivate func handleRefresh() {
        print("Refreshing....")
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserID()
    }
    
    fileprivate func fetchFollowingUserID() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            guard let useridDictionary = snapshot.value as? [String: Any] else {return}
            useridDictionary.forEach { key, value in
                Database.fetchUserWithUID(uid: key) { user in
                    self.fetchPostsWithUser(user: user)
                }
            }
        } withCancel: { err in
            print("Failed to fetch following's posts...", err)
        }
    }
    
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }
      
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { snapshot in
                    print(snapshot)
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort { p1, p2 in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    }
                    self.collectionView.reloadData()
                } withCancel: { err in
                    print("Failed to fetch liked posts",err)
                }
            }
            
            
        } withCancel: { err in
             print("ERROR", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! HomePostCell
        if posts.count > 0 {
            let post = self.posts[indexPath.item]
            cell.post = post
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return .init(width: collectionView.frame.width, height: height)
    }
    
    
    func didLike(for cell: HomePostCell) {
        print("Like from Home Controller")
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = posts[indexPath.item]
        print(post.caption)
        
        
        guard let postID = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postID).updateChildValues(values) { err, _ in
            if let err = err {
                print("Failed to like the post", err)
                return
            }
            print("Successfully liked the post.")
            print("User id \(uid) like the that post \(postID)")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
    func didTapComment(post: Post) {
        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
