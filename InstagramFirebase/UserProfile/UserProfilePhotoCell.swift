//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 15.08.2023.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    
    var post: Post? {
        didSet{
//            print(post?.imageURL ?? "")
            print(1)
            guard let imageURL = post?.imageURL else {return}
            photoImageView.loadImage(urlString: imageURL)
         
        }
    }
    
    let photoImageView: CustomImageView = {
       let imageView = CustomImageView()
        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
