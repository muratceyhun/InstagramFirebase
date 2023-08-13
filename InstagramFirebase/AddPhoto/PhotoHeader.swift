//
//  PhotoHeader.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2023.
//

import UIKit

class PhotoHeader: UICollectionViewCell {
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
            
        }
    }
    
    let photoImageView: UIImageView = {
       let photo = UIImageView()
        photo.backgroundColor = .purple
        return photo
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
