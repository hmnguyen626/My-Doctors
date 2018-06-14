//
//  ContainerViewController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/13/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //--------------------------------------------------------------------------------------------
    //MARK - Views
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "MainbackgroundImage2"))
        
        // Enable constraints to autoresize
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    let loginContainerView: UIView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 153/255, green: 179/255, blue: 255/255, alpha: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let usernameTextField: MadokaTextField = {
        let customTextField = MadokaTextField()
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Username"
        customTextField.placeholderFontScale = 0.8
        customTextField.keyboardType = .emailAddress
        
        //test
        customTextField.borderColor = UIColor.white
        customTextField.font = UIFont(name: "Menlo-Regular", size: 20)
        customTextField.placeholderColor = UIColor.white
        customTextField.textColor = UIColor.white
        
        return customTextField
    }()
    
    let passwordTextField: MadokaTextField = {
        let customTextField = MadokaTextField()
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Password"
        customTextField.placeholderFontScale = 0.8
        customTextField.isSecureTextEntry = true
        
        //test
        customTextField.borderColor = UIColor.white
        customTextField.font = UIFont(name: "Menlo-Regular", size: 20)
        customTextField.placeholderColor = UIColor.white
        customTextField.textColor = UIColor.white
        
        return customTextField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.6)
        
        return button
    }()
    
    let notAUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.text = "Not a user?    |"
        label.text = "Reset Password |     Register"

        label.textColor = UIColor.white
        label.font = UIFont(name:  "Menlo-Regular", size: 15)
        
        return label
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
        setupLogin()
    }
    
    func setupBackground(){
        // Add our subView to current view
        view.addSubview(backgroundImageView)

        // Set up constraints
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.contentMode = .scaleToFill
    }
    
    func setupLogin(){
        // Add subview to BackgroundImageView
        backgroundImageView.addSubview(loginContainerView)
        loginContainerView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        loginContainerView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: 0.0).isActive = true
        loginContainerView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
        loginContainerView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor).isActive = true
        
        // Textfields
        view.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: loginContainerView.topAnchor, constant: 250).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor, constant: -50).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor, constant: 50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: 70).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor, constant: -50).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor, constant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // Buttons
        view.addSubview(loginButton)
        loginButton.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor, constant: -50).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor, constant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 90).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // Rounded corners
        loginButton.layoutIfNeeded()    // Important line
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.masksToBounds = true
        
        
        
        // Labels
        view.addSubview(notAUserLabel)
        notAUserLabel.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 70).isActive = true
        notAUserLabel.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor, constant: 50).isActive = true
        
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - Textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
//            self.loginContainerView.frame.origin.y -= 100
//            self.passwordTextField.frame.origin.y -= 100
//            self.usernameTextField.frame.origin.y -= 100

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
//            self.loginContainerView.frame.origin.y += 100
//            self.passwordTextField.frame.origin.y += 100
//            self.usernameTextField.frame.origin.y += 100
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}











