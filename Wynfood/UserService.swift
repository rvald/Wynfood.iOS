//
//  UserService.swift
//  Wynfood
//
//  Created by craftman on 6/5/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation

class UserService {
    
    // MARK: - Properties
    private var userForEmail: User! 
  
    
    // MARK: - Methods
    func parseJsonData(jsonObject: Dictionary<String, AnyObject>) {
        
        let email = jsonObject["email"] as! String
        let userName = jsonObject["userName"] as! String
        let created = jsonObject["created"]
        
        userForEmail = User(email: email, userName: userName, created: created)
        
        print("Created user: \(userForEmail)")

    }
    
    func user() -> User {
        return userForEmail
    }
    
    
}
