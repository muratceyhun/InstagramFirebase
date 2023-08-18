//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 16.08.2023.
//

import UIKit


var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                print("Failed to get images for UI", err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }

            guard let data = data else {return}
            let photoImage = UIImage(data: data)
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage

            }
        }.resume()
        
    }
}
