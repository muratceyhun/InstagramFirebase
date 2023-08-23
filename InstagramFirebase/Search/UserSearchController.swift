//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 22.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbConverter(red: 240, green: 240, blue: 240, alpha: 1)
        sb.delegate = self
        return sb
    }()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUsers = users
        } else {
            self.filteredUsers = users.filter { user in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
//        let navBar = navigationController?.navigationBar
        navigationItem.titleView = searchBar  //This enable us to fit without anchor method
//        navigationController?.navigationBar.addSubview(searchBar)
//        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, topPadding: 0, leadingPadding: 8, trailingPadding: -8, bottomPadding: 0, width: 0, height: 0)
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "cellID")
        
        collectionView.alwaysBounceVertical = true
//        collectionView.alwaysBounceHorizontal = true
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
//            print(snapshot)
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach { key, value in
                
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
                print(user.uid, user.username)
            }
//            self.users.sort { u1, u2 in
//                return u1.username.compare(u2.username) == .orderedAscending
//            }
            self.users.sort {$0.username < $1.username} // Ordering for alphabet in a short way...
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        } withCancel: { err in
            print("Failed to get users to search", err)
        }

    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! SearchCell
        let user = filteredUsers[indexPath.item]
        cell.user = user
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 66)
    }
}
