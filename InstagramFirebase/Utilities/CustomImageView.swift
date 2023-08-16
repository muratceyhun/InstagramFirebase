//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 16.08.2023.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                print("Failed to get images for UI", err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
//            if url.absoluteString != self.post?.imageURL {
//                return
//            }
            guard let data = data else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: data)

            }
        }.resume()
        
    }
}
