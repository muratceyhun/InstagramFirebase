//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 7.08.2023.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        print(index)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = SpecifiedNavController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            return false
        }
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
        setupViewControllers()
    }
    
    func setupViewControllers() {
        
        // Home Screen
        
        let homeNavController = templateNavController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()), selectedPhoto: "home_selected", unselectedPhoto: "home_unselected")
        
        
        // Search Screen
        
        let searchNavController = templateNavController(rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()), selectedPhoto: "search_selected", unselectedPhoto: "search_unselected")
        
        
        
        // Plus Screen
        
        let plusNavController = templateNavController(selectedPhoto: "plus_unselected", unselectedPhoto: "plus_unselected")
        
        // Like Screen
        
        let likeNavcontroller = templateNavController(selectedPhoto: "like_selected", unselectedPhoto: "like_unselected")

        
        // User Profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userNavController = UINavigationController(rootViewController: userProfileController)
        userNavController.tabBarItem.image = UIImage(named: "profile_unselected")
        userNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavcontroller, userNavController]
        
        
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    fileprivate func templateNavController(rootViewController: UIViewController = UIViewController(),
                                           selectedPhoto: String,
                                           unselectedPhoto: String) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedPhoto)
        navController.tabBarItem.selectedImage = UIImage(named: selectedPhoto)
        tabBar.tintColor = .black
        return navController
    }
}
