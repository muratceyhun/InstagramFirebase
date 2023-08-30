//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 29.08.2023.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            print(comment?.text ?? "")
            guard let comment = comment else {return}

            let attrString = NSMutableAttributedString(string: comment.user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
            attrString.append(NSAttributedString(string: " " + comment.text, attributes: [.font : UIFont.systemFont(ofSize: 14)]))
            textLabel.attributedText = attrString
            profileImageView.loadImage(urlString: comment.user.profileImageURL)
        }
    }
    
    
    let profileImageView: CustomImageView = {
       let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    let textLabel: UITextView = {
       let textView = UITextView()
        textView.isScrollEnabled = false
//        label.numberOfLines = 0
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 8, leadingPadding: 8, trailingPadding: 0, bottomPadding: 0, width: 40, height: 40)
//        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 4, leadingPadding: 4, trailingPadding: -4, bottomPadding: -4, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
