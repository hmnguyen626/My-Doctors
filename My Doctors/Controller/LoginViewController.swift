//
//  ContainerViewController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/13/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects
import SVProgressHUD
import RealmSwift


class LoginViewController: UIViewController {
    
    //MARK: - Views

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 153/255, green: 179/255, blue: 255/255, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let usernameTextField: MadokaTextField = {
        let customTextField = MadokaTextField()
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.placeholder = "Username"
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
        customTextField.placeholder = "Password"
        customTextField.placeholderFontScale = 0.8
        customTextField.isSecureTextEntry = true
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
        button.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = 1
        
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 15)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = 2
        
        return button
    }()
    
    let notAUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reset Password |"
        label.textColor = UIColor.white
        label.font = UIFont(name:  "Menlo-Regular", size: 15)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        setupView()
        
    }

    //MARK: - NavigationBar hide/show
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        resetView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        
        resetView()
    }
    
    //MARK: - UISetups
    private func setupView(){
        setupBackground()
        setupLogin()
    }
    
    func resetView(){
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func setupBackground(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "MainbackgroundImage2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    func setupLogin(){
        // Add subview to BackgroundImageView
        view.addSubview(containerView)
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
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
        view.addSubview(loginButton)
        loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 90).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // Rounded corners
        loginButton.layoutIfNeeded()    // Important line "DEFINITION: layoutIfNeeded forces layout early"
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.layer.masksToBounds = true
        view.addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 64).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -80).isActive = true
        
        // Labels
        view.addSubview(notAUserLabel)
        notAUserLabel.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 70).isActive = true
        notAUserLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
        
    }
    
    //MARK: - Button functions
    @objc func buttonAction(sender: UIButton!){

        if sender.tag == 1 {
            
            // Login method and performSegue
            loginUser()
            
        }
        else if sender.tag == 2{
            
            // Go to registration view
            performSegue(withIdentifier: "goToRegisterID", sender: self)
            
        }
        
    }
    
    //MARK: - Firebase Auth
    func loginUser(){
        SVProgressHUD.show()
        
        //Log in the user with Firebase
        //https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth#signinwithemailpasswordcompletion
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                // Present an alert to user
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                // Clears current view's text fields
                self.resetView()
                
                SVProgressHUD.dismiss()
            } else {
                
                // Go to Dashboard
                self.performSegue(withIdentifier: "goToDashID", sender: self)
                SVProgressHUD.dismiss()
            }
        }
    }
}

//MARK: - UITextField Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    
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
}









