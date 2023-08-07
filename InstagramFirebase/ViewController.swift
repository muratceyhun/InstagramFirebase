//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Murat Ceyhun Korpeoglu on 4.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleAddPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = 150/2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        dismiss(animated: true)
    }
    
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Email"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    @objc func handleTextInputChange () {
        let formValid = emailTextField.hasText && userNameTextField.hasText && passwordTextField.hasText
    
        if formValid {
            signupButton.backgroundColor = UIColor.rgbConverter(red: 17, green: 154, blue: 237, alpha: 1)
            signupButton.isEnabled = true
        } else {
            signupButton.backgroundColor = UIColor.rgbConverter(red: 149, green: 204, blue: 244, alpha: 1)
            signupButton.isEnabled = false
        }
    }
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Username"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.placeholder = "Password"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        return textField
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.setTitle("Sign Up", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor.rgbConverter(red: 149, green: 204, blue: 244, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = userNameTextField.text else {return}
        print(username)
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("ERROR", err)
                return
            }
            print("Created user successfully...", user?.user.uid ?? "")
            
            //Upload Photo
            
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            let fileName = NSUUID().uuidString
            
            
            // Firebase Storage
            Storage.storage().reference().child("profile_images").child(fileName).putData(uploadData) { metadata, err in
                if let err = err {
                    print("ERROR", err)
                    return
                }
                
                Storage.storage().reference().child("profile_images").child(fileName).downloadURL { url, err in
                    if let err = err {
                        print("ERROR", err)
                        return
                    }
                    
                    guard let profilePhotoURL = url?.absoluteString else {return}
                    print(profilePhotoURL)
                    
                    
                    guard let uid = user?.user.uid else {return}
                    let dictValues = ["username": username, "profilePhotoURL": profilePhotoURL]
                    let values = [uid: dictValues]

                    Database.database().reference().child("users").updateChildValues(values) { err, ref in
                        if let err {
                            print("Failed to save user info into db:", err)
                        }

                        print("Saved the user into the db successfully")
                    }
                }
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        setupPlusPhotoButton()
        setupFields()
    }
    
    
    func setupPlusPhotoButton() {
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, topPadding: 24, leadingPadding: 0, trailingPadding: 0, bottomPadding: 0, width: 150, height: 150)
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

