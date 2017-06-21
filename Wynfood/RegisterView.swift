//
//  RegisterView.swift
//  Wynfood
//
//  Created by craftman on 6/2/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    let authService = AuthenticationService()
    let networkingService = NetworkingService()
    let dismissViewNotification = Notification.Name("WynfoodDismissViewNotification")
    let presentAlertNotification = Notification.Name("WynfoodPresentAlertNotification")
    
    
    // MARK: - Initialization
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
        field.placeholder = "User@gmail.com"
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
    
    lazy var passwordField1: UITextField = {
        
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
    
    let registerButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(registerButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    let passwordInfoLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Password must be at least 6 characters long, and include a capital letter and a number."
        label.numberOfLines = 0
        label.textColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    // MARK: - Methods
    func setupView() {
        
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(passwordField1)
        addSubview(registerButton)
        addSubview(passwordInfoLabel)
        
        
        // email field constraints
        addConstraint(NSLayoutConstraint(item: emailField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 1.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailField]))
        
        // password fields constraints
        addConstraint(NSLayoutConstraint(item: passwordField, attribute: .top, relatedBy: .equal, toItem: emailField, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField]))
        
        addConstraint(NSLayoutConstraint(item: passwordField1, attribute: .top, relatedBy: .equal, toItem: passwordField, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField1]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": passwordField1]))
        
        // password info constraints
        addConstraint(NSLayoutConstraint(item: passwordInfoLabel, attribute: .top, relatedBy: .equal, toItem: passwordField1, attribute: .bottom, multiplier: 1.0, constant: 8.0))
        addConstraint(NSLayoutConstraint(item: passwordInfoLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 1.0))
        addConstraint(NSLayoutConstraint(item: passwordInfoLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 1.0))
        
        // register button constraints
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: passwordInfoLabel, attribute: .bottom, multiplier: 1.0, constant: 24.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": registerButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": registerButton]))
        
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "^(?=.{6,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    func isEmailAndPasswordValid() -> Bool {
        
        var valid = true
        
        if !validateEmail(candidate: emailField.text!) || !validatePassword(candidate: passwordField.text!) || !validatePassword(candidate: passwordField1.text!) {
            
            valid = false
            
            let infoMessage: [String: String]  = ["message": "Please enter Email or Password."]
            NotificationCenter.default.post(name: presentAlertNotification, object: nil, userInfo: infoMessage)
            
            emailField.text = ""
            passwordField.text = ""
            passwordField1.text = ""
            
            registerButton.setTitle("Register", for: .normal)
            
        } else if (passwordField.text != passwordField1.text) {
            
            valid = false
            
            let info: [String: String]  = ["message": "Password and password confirm do not match."]
            NotificationCenter.default.post(name: presentAlertNotification, object: nil, userInfo: info)
            
            registerButton.setTitle("Register", for: .normal)
        }
        
        return valid
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            
            if emailField.isFirstResponder || passwordField.isFirstResponder || passwordField1.isFirstResponder  {
               
                emailField.resignFirstResponder()
                passwordField.resignFirstResponder()
                passwordField1.resignFirstResponder()
                
            }
        }
    }
    
    // MARK: - Actions
    func registerButtonTap(sender: UIButton, forEvent event: UIEvent) {
        
        UIView.animate(withDuration: 0.8) {
            sender.setTitle("Creating Account ...", for: .normal)
        }
        
        if isEmailAndPasswordValid() {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if let error = error {
                
                    let info: [String: String]  = ["message": error.localizedDescription]
                    NotificationCenter.default.post(name: self.presentAlertNotification, object: nil, userInfo: info)
                    
                    self.registerButton.setTitle("Register", for: .normal)
                    
                    return
                    
                } else {
                    
                    guard let email = self.authService.getUserEmail() else { return }
                    
                    let userName = self.authService.userNameFromEmail(email: email.lowercased())
                    
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: "UserEmail")
                    defaults.set(userName, forKey: "UserName")
                    
                    NotificationCenter.default.post(name: self.dismissViewNotification, object: nil)
                    
                    self.registerButton.setTitle("Register", for: .normal)
                    
                }
            }
        }
    }
    
    
    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        
        return true
    }
    
}
