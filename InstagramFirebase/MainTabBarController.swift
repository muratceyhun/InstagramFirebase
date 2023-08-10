//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
   
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}