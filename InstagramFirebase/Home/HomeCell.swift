//
//  HomeCell.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 18.08.2023.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            guard let postURL = post?.imageURL else {return}
            photoImageView.loadImage(urlString: postURL)
            usernameLabel.text = post?.user.username
            guard let profileImageURL = post?.user.profileImageURL else {return}
            userProfileImageView.loadImage(urlString: profileImageURL)
//            captionLabel.text = post?.caption
            setupAttributedCaption()

            
            
        }
    }
    
    let userProfileImageView: CustomImageView = {
       let userphoto = CustomImageView()
        userphoto.layer.cornerRadius = 40/2
        userphoto.clipsToBounds = true
//        userphoto.layer.masksToBounds = true
        return userphoto
    }()
    
    let photoImageView: CustomImageView = {
        let photo = CustomImageView()
        photo.backgroundColor = .lightGray
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "USER NAME"
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else {return}
        
        let attrString = NSMutableAttributedString(string: post.user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrString.append(NSAttributedString(string: " \(post.caption)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attrString.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        
        attrString.append(NSAttributedString(string: timeAgoDisplay, attributes: [.foregroundColor : UIColor.gray, .font : UIFont.systemFont(ofSize: 14)]))
        captionLabel.attributedText = attrString
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(optionsButton)
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sentButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(bookmarkButton)
        addSubview(captionLabel)
        
        
        
        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 8, leadingPadding: 8, trailingPadding: 0, bottomPadding: 0, width: 40, height: 40)
        
        usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor, trailing: optionsButton.leadingAnchor, bottom: photoImageView.topAnchor, topPadding: 0, leadingPadding: 8, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)

        photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 8, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        optionsButton.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: photoImageView.topAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 44, height: 0)
        
        stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 0, leadingPadding: 4, trailingPadding: 0, bottomPadding: 0, width: 120, height: 50)
        
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 40, height: 50)
        
        captionLabel.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 8, trailingPadding: -8, bottomPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
