//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 28.08.2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var post: Post?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = .onDrag
//        collectionView.contentInset = .init(top: 0, left: 0, bottom: -84, right: 0)
        navigationItem.title = "Comments"
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.alwaysBounceVertical = true
        fetchComments()
    }
    
    
    fileprivate func fetchComments() {
        guard let postID = self.post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postID)
        ref.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUserWithUID(uid: uid) { user in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
            
        
            
        } withCancel: { err in
            print("Failed to fetch comments", err)
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 84)
        
        
        lazy var submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, leading: nil, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: -12, bottomPadding: 0, width: 50, height: 0)
       
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.rgbConverter(red: 210, green: 230, blue: 230, alpha: 1)
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0.6)
    
        containerView.addSubview(commentTextField)
        self.commentTextField.anchor(top: nil, leading: containerView.leadingAnchor, trailing: submitButton.leadingAnchor, bottom: nil, topPadding: 0, leadingPadding: 12, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
        submitButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor).isActive = true
        
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter a comment"
        return textField
    }()
    
    override var inputAccessoryView: UIView? {
        get {
           return containerView
        }
    }
    
    @objc fileprivate func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("POST ID \(post?.id ?? "")")
        guard let postID = post?.id else {return}
        let values = ["text": commentTextField.text ?? "",
                      "creadtionDate": Date().timeIntervalSince1970,
                      "uid": uid
        ] as [String: Any]
        Database.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { err, ref in
            if let err = err {
                print("Failed to push comment to the DB", err)
            }
            
            print("Successfully submitted comment to the DB")
            
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        cell.comment = comment
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
