//
//  LoginViewController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 10.08.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logo = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logo.contentMode = .scaleAspectFill
        view.addSubview(logo)
        logo.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 200, height: 50)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgbConverter(red: 0, green: 120, blue: 175, alpha: 1)
        return view
    }()
    
    
    let emailTextField: UITextField = {
       let email = UITextField()
        email.placeholder = "Email"
        email.textColor = .lightGray
        email.borderStyle = .roundedRect
        return email
    }()
    
    let passwordTextField: UITextField = {
       let password = UITextField()
        password.placeholder = "Password"
        password.textColor = .lightGray
        password.borderStyle = .roundedRect
        return password
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgbConverter(red: 0, green: 120, blue: 175, alpha: 0.4)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        print("LOGINNNNNNNN")
    }
    
    
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attrString = NSMutableAttributedString(string: "Don't have an account? ", attributes: [.foregroundColor : UIColor.lightGray])
        attrString.append(NSAttributedString(string: "Sign Up.", attributes: [.foregroundColor : UIColor.rgbConverter(red: 17, green: 154, blue: 237, alpha: 1), .font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attrString, for: .normal)
        button.addTarget(self, action: #selector(goToSignUPVC), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func goToSignUPVC() {
        
        let vc = SignUpController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoContainerView)

        logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 0, height: 150)
        view.addSubview(signUpButton)
        navigationController?.isNavigationBarHidden = true
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topPadding: 0, leadingPadding: 0, trailingPadding: 0, bottomPadding: -56, width: 0, height: 40)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topPadding: 40, leadingPadding: 40, trailingPadding: -40, bottomPadding: 0, width: 0, height: 144)
    }
}
