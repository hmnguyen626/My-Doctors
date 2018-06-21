//
//  RegisterNavigationController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/14/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects
import SVProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {

    //--------------------------------------------------------------------------------------------
    //MARK - Declare views
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 153/255, green: 179/255, blue: 255/255, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let usernameTextField: MadokaTextField = {
        let customTextField = MadokaTextField()
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Enter Email"
        customTextField.placeholderFontScale = 0.8
        customTextField.keyboardType = .emailAddress
        customTextField.borderColor = UIColor.white
        customTextField.font = UIFont(name: "Menlo-Regular", size: 20)
        customTextField.placeholderColor = UIColor.white
        customTextField.textColor = UIColor.white
        
        return customTextField
    }()
    
    let passwordTextField: MadokaTextField = {
        let customTextField = MadokaTextField()
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Enter Password"
        customTextField.placeholderFontScale = 0.8
        customTextField.isSecureTextEntry = true
        customTextField.borderColor = UIColor.white
        customTextField.font = UIFont(name: "Menlo-Regular", size: 20)
        customTextField.placeholderColor = UIColor.white
        customTextField.textColor = UIColor.white
        
        return customTextField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.6)
        button.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 15)
        
        // Action
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = 1
        
        return button
    }()
    
    let goBackNavBarButton: UINavigationItem = {
        let navBarButton = UINavigationItem()
        
        
        return navBarButton
    }()
    
    //--------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Set up our viewcontroller on load
        setupView()
        

        
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - UISetups
    
    private func setupView(){
        setupBackground()
        setupRegister()
    }
    
    func setupBackground(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "MainbackgroundImage2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func setupRegister(){
        // Add subview to BackgroundImageView
        view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // Textfields
        view.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 250).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: 90).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // Buttons
        view.addSubview(registerButton)
        registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 90).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // Rounded corners
        registerButton.layoutIfNeeded()    // Important line "DEFINITION: layoutIfNeeded forces layout early"
        registerButton.layer.cornerRadius = registerButton.frame.size.height / 2
        registerButton.layer.masksToBounds = true
        
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - Textfield delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Dismiss keyboard when user taps view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - Button functions
    
    @objc func buttonAction(sender: UIButton!){
        SVProgressHUD.show()
        let senderTag: UIButton = sender
        
        // Register button pressed
        if senderTag.tag == 1 {
            registerNewUser()
        }
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - Firebase Create user
    //Use FirebaseAuth method createUser() to register a new user to our database, else throw an alert w/ error description to user
    func registerNewUser(){
        
        //https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth#createuserwithemailpasswordcompletion
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            // Check if any error is sent back from callback
            if error != nil {
                
                // Present an alert to user
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                SVProgressHUD.dismiss()
            } else {
                
                //Pop to rootview Controller "Login"
                //https://stackoverflow.com/questions/26755916/how-to-go-back-to-rootviewcontroller-from-presentview-controller
                self.navigationController?.popToRootViewController(animated: true)
                
                SVProgressHUD.dismiss()
            }
        }
    }
    
}

    


