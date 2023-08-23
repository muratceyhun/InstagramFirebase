//
//  SearchCell.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 22.08.2023.
//

import UIKit


class SearchCell: UICollectionViewCell {
    
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else {return}
            profileImageView.loadImage(urlString: profileImageURL)
            userNameLabel.text = user?.username
        }
    }
    
    let profileImageView: CustomImageView = {
       let image = CustomImageView()
        image.layer.cornerRadius = 50/2
        image.layer.masksToBounds = true
        return image
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(userNameLabel)
        profileImageView.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 0, leadingPadding: 8, trailingPadding: 0, bottomPadding: 0, width: 50, height: 50)
        userNameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 4, trailingPadding: 0, bottomPadding: 0, width: 0, height: 20)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: userNameLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
