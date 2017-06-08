//
//  LogInView.swift
//  Wynfood
//
//  Created by craftman on 6/2/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import FirebaseAuth


class LogInView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    let authService = AuthenticationService()
    let dismissViewNotification = Notification.Name("WynfoodDismissViewNotification")
    let presentAlertNotification = Notification.Name("WynfoodPresentAlertNotification")
    let networkingService = NetworkingService()

    // MARK: - Intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    lazy var emailField: UITextField = {
        
        let field = UITextField()
        field.placeholder = "User@email.com"
        field.borderStyle = .none
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 5.0
        field.textAlignment = .center
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
        
    }()
    
    lazy var passwordField: UITextField = {
        
        let field = UITextField()
        field.placeholder = "Password1"
        field.borderStyle = .none
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 5.0
        field.textAlignment = .center
        field.isSecureTextEntry = true
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
        
    }()
    
    let logInButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(logInButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    // MARK: - Methods
    func setupView() {
        
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(logInButton)
        
        // name field constraints
        addConstraint(NSLayoutConstraint(item: emailField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailField]))
        
        // password field constraints
        addConstraint(NSLayoutConstraint(item: passwordField, attribute: .top, relatedBy: .equal, toItem: emailField, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField]))
        
        // login button constraints
        addConstraint(NSLayoutConstraint(item: logInButton, attribute: .top, relatedBy: .equal, toItem: passwordField, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": logInButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": logInButton]))
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if emailField.isFirstResponder || passwordField.isFirstResponder {
                emailField.resignFirstResponder()
                passwordField.resignFirstResponder()
            }
        }
    }
    
    
    // MARK: - Actions
    func logInButtonTap(sender: UIButton, forEvent event: UIEvent) {
        
        UIView.animate(withDuration: 0.7) {
            sender.setTitle("Logging in ...", for: .normal)
        }
        
        if authService.isEmailAndPasswordValid(email: emailField.text!, password: passwordField.text!) {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    
                    print(error?.localizedDescription as Any)
                    
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.logInButton.setTitle("Log In", for: .normal)
                    
                    return
                    
                } else {
                    
                    let email = self.emailField.text!
                    
                    let userName = self.authService.userNameFromEmail(email: email)
                    
                    let defaults = UserDefaults.standard
                    
                    defaults.set(userName, forKey: "UserName")
                    defaults.set(email, forKey: "UserEmail")
                   
                    NotificationCenter.default.post(name: self.dismissViewNotification, object: nil)
                }
            }
            
        } else {
            
            let info: [String: String]  = ["message": "Invalid email or password"]
            NotificationCenter.default.post(name: presentAlertNotification, object: nil, userInfo: info)
            self.logInButton.setTitle("Log In", for: .normal)
        }
        
    }
    
    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        resignFirstResponder()
        
        return true
    }

    
}

