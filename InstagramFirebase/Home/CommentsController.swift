//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 28.08.2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class CommentsController: UICollectionViewController {
    
    
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .lightGray
        collectionView.keyboardDismissMode = .onDrag
        navigationItem.title = "Comments"
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
        
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 150)
        
        
        lazy var submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, leading: nil, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: -4, bottomPadding: 0, width: 50, height: 0)
       
    
        containerView.addSubview(commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: submitButton.leadingAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, topPadding: 0, leadingPadding: 12, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        
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
    
    
    
    
}
