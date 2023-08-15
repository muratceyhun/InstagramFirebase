//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2023.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

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
        
        if contentTextView.hasText {
            guard let image = selectedImage else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
            let filename = NSUUID().uuidString
            
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            
            Storage.storage().reference().child("posts").child(filename).putData(uploadData) { metadata, err in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to put photo to DB ", err)
                    return
                }
                
                print("Successfully downloaded to DB", metadata)
                
                
                Storage.storage().reference().child("posts").child(filename).downloadURL { imageURL, err in
                    if let err = err {
                        print("Failed to get url", err)
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        return
                    }
                    guard let imageURL = imageURL?.absoluteString else {return}
                    print(imageURL)
                    
                    self.saveToDatabaseWithImageURL(imageURL: imageURL)
                }
            }
        }
       
    }
    
    fileprivate func saveToDatabaseWithImageURL(imageURL: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let image = selectedImage else {return}
        guard let caption = contentTextView.text else {return}
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        guard let values = ["imageURL": imageURL, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970] as? [String: Any] else {return}
        ref.updateChildValues(values) { err, ref in
            if let err = err {
                print("Failed to save to DB", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true)
        }
    }
}
