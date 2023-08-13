//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2023.
//

import UIKit

class SharePhotoController: UIViewController {
    
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    let containerView = UIView()
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    let contentTextView: UITextView = {
       let content = UITextView()
        content.backgroundColor = .lightGray
        return content
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbConverter(red: 240, green: 240, blue: 240, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
        view.addSubview(containerView)
        containerView.backgroundColor = .brown
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 100)
        containerView.addSubview(photoImageView)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: containerView.leadingAnchor, trailing: nil, bottom: nil, topPadding: 8, leadingPadding: 8, trailingPadding: 0, bottomPadding: 0, width: 80, height: 80)
        containerView.addSubview(contentTextView)
        contentTextView.anchor(top: photoImageView.topAnchor, leading: photoImageView.trailingAnchor, trailing: containerView.trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 8, trailingPadding: -4, bottomPadding: 0, width: 0, height: 80)
    }
    
    @objc fileprivate func handleShare() {
        print("Shareeee")
    }
}
