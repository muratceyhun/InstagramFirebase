//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 22.08.2023.
//

import UIKit

class UserSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbConverter(red: 240, green: 240, blue: 240, alpha: 1)
        return sb
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, topPadding: 0, leadingPadding: 8, trailingPadding: -8, bottomPadding: 0, width: 0, height: 0)
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "cellID")
        
        collectionView.alwaysBounceVertical = true
//        collectionView.alwaysBounceHorizontal = true
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 66)
    }
}
