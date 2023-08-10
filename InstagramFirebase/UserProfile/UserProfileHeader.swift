//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 9.08.2023.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
            //            print(user?.username)
            
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        //        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topPadding: 12, leadingPadding: 12, trailingPadding: 0, bottomPadding: 0, width: 80, height: 80)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupProfileImage() {
        
        guard let profileImageURL = user?.profileImageURL else {return}
        guard let url = URL(string: profileImageURL) else {return}
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("ERROR", err)
            }
            
            print(data)
            guard let data = data else {return}
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
                
            }
        }.resume()
        
    }
}
