//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 4.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Email"
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Username"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Password"
        return textField
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.setTitle("Sign Up", for: .normal)
//        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.backgroundColor = UIColor.rgbConverter(red: 149, green: 204, blue: 244, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc func handleSignUp() {
        print("12112121221")
    }
        
    
    @objc fileprivate func handleAddPhoto() {
        print("****")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        setupPlusPhotoButton()
        setupFields()
    }
    
    
    func setupPlusPhotoButton() {
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, topPadding: 24, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 150)
    }
    
    func setupFields() {
        
        let stackView: UIStackView = {
           let stack = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signupButton])
            stack.distribution = .fillEqually
            stack.axis = .vertical
            stack.spacing = 10
            return stack
        }()
        
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topPadding: 20, leadingPadding: 24, trailingPadding: -24, bottomPadding: 0, width: 0, height: 224)

    }


}

