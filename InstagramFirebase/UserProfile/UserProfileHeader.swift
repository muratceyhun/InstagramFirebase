//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 9.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else {return}
            profileImageView.loadImage(urlString: profileImageURL)
//            setupProfileImage()
            username.text = user?.username
            
            setupEditFollowButton()
            
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgbConverter(red: 17, green: 154, blue: 237, alpha: 1)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupUnfollowStyle() {
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
    }
    fileprivate func setupEditFollowButton() {
        
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else {return}
        
        guard let userID = user?.uid else {return}
        
        if currentLoggedInUserID == userID {
            editProfileFollowButton.isEnabled = false
        } else {
            
            // Check if following
            
            Database.database().reference().child("following").child(currentLoggedInUserID).child(userID).observeSingleEvent(of: .value) { snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setupUnfollowStyle()

                } else {
                    self.setupFollowStyle()
                }
            } withCancel: { err in
                print("Failed to check follow", err)
            }

        }
    }
    
    @objc fileprivate func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else {return}
        guard let userID = user?.uid else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            Database.database().reference().child("following").child(currentLoggedInUserID).child(userID).removeValue { err, ref in
                if let err = err {
                    print("Failed to unfollow", err)
                    return
                }
                
                print("Successfully unfollowed", self.user?.username ?? "")
                self.setupFollowStyle()
                
            }
        } else {
            
            let ref = Database.database().reference().child("following").child(currentLoggedInUserID)
            let values = [userID: 1]
            ref.updateChildValues(values) { err, red in
                if let err = err {
                    print("Failed to follow user", err)
                }
                
                print("Successfully followed: \(self.user?.username ?? "") ")
                self.setupUnfollowStyle()
            }
        }
    
    }
    
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        //        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor.red
        return button
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "23\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSMutableAttributedString(string: "posts", attributes: [.foregroundColor : UIColor.lightGray.cgColor, .font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attrText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followersLabel: UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "24\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSMutableAttributedString(string: "followers", attributes: [.foregroundColor : UIColor.lightGray.cgColor, .font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attrText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel: UILabel = {
        let label = UILabel()
        let attrText = NSMutableAttributedString(string: "45\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSMutableAttributedString(string: "following", attributes: [.foregroundColor : UIColor.lightGray.cgColor, .font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attrText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    

    
    fileprivate func setupUserStatsView() {
        let stackview = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 12, leadingPadding: 4, trailingPadding: -12, bottomPadding: 0, width: 0, height: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 12, leadingPadding: 12, trailingPadding: 0, bottomPadding: 0, width: 80, height: 80)
        addSubview(username)
        username.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 24, leadingPadding: 16, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        setupButtonToolbar()
        setupUserStatsView()
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, leading: postLabel.leadingAnchor, trailing: followingLabel.trailingAnchor, bottom: nil, topPadding: 2, leadingPadding: 16, trailingPadding: 0, bottomPadding: 0, width: 0, height: 36)
    }
    
    fileprivate func setupButtonToolbar() {
        
        let upLine = UIView()
        upLine.backgroundColor = .lightGray
        
        let downLine = UIView()
        downLine.backgroundColor = .lightGray
        
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 50)
        
        addSubview(upLine)
        upLine.anchor(top: stackView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
        addSubview(downLine)
        downLine.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
