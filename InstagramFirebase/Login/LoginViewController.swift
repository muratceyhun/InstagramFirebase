//
//  LoginViewController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 10.08.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(goToSignUPVC), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func goToSignUPVC() {
        
        let vc = SignUpController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signUpButton)
        navigationController?.isNavigationBarHidden = true
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: -56, width: 0, height: 40)
    }
}
