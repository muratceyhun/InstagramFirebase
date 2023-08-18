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
            
        }
    }
    
    let photoImageView: CustomImageView = {
        let photo = CustomImageView()
        photo.backgroundColor = .lightGray
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
