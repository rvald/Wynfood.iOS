//
//  AuthenticationService.swift
//  Wynfood
//
//  Created by craftman on 5/25/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation
import FirebaseAuth

struct AuthenticationService {
    
    // MARK: - Methods
    func isUserLoggedIn() -> Bool {
        
        var loggedIn = false
        
        if Auth.auth().currentUser != nil {
            loggedIn = true
        }
        
        return loggedIn
    }
    
    func getUserName() -> String {
        
        let defaults = UserDefaults.standard
        let userName = defaults.object(forKey: "UserName") as! String
       
        return userName
    }
    
    func getUserEmail() -> String? {
        
        return Auth.auth().currentUser?.email
    }
    
    func logOut() {
        try! Auth.auth().signOut()
    }
    
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "^(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    func isEmailAndPasswordValid(email: String, password: String) -> Bool {
        return validateEmail(candidate: email) && validatePassword(candidate: password)
    }
    
    func isEmailValid(email: String) -> Bool {
        return validateEmail(candidate: email)
    }
    
    func isPasswordValid(password: String) -> Bool {
        return validatePassword(candidate: password)
    }
    
    func isPasswordConfirmend(password: String, passwordConfirm: String) -> Bool {
        return password == passwordConfirm
    }
    
    func userNameFromEmail(email: String) -> String {
        
        var userName = ""
        
        for c in email.characters {
            
            if c != "@" {
                
                userName.append(c)
                
            } else {
                
                break
            }
        }
        
        return userName
    }
    


}
