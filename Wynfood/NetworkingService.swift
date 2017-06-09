//
//  NetworkingService.swift
//  Wynfood
//
//  Created by craftman on 5/23/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation

class NetworkingService {
    
    // constants
    enum Request {
        static let ratings = "https://boiling-falls-56738.herokuapp.com/api/ratings/"
    }
    
    // MARK: - Methods
    func getRatings(completion: @escaping ([Dictionary<String, AnyObject>]) -> Void) {
    
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithOutDelegate = URLSession(configuration: defaultConfiguration)
        let requestUrl = URL(string: Request.ratings)
    
        sessionWithOutDelegate.dataTask(with: requestUrl!, completionHandler: { (data, response, error) in
    
            if let error = error {
    
                print("Error: \(error.localizedDescription)")
    
                return
    
            } else {
    
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Dictionary<String, AnyObject>]
    
                if let _jsonData = jsonData {
    
                    completion(_jsonData)
                }
            }
            
        }).resume()
    }

    
    func postRating(rating: Rating) {
    
        let parameters = ["restaurantId": rating.restaurantId , "userName": rating.userName , "text": rating.text , "value": rating.value ] as [String : Any]
        
        let defaultConfiguration = URLSessionConfiguration.default
        let sessionWithOutDelegate = URLSession(configuration: defaultConfiguration)
        let url = URL(string: Request.ratings)
        
        var request = URLRequest(url: url!)
    
        request.httpMethod = "POST"
    
        do {
    
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    
        } catch {
    
            print(error.localizedDescription)
        }
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        let task = sessionWithOutDelegate.dataTask(with: request) { (data, response, error) in
    
            if let error = error {
    
                print(error.localizedDescription)
                return
    
            } else {
    
                if let data = data {
    
                    do {
    
                        try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    
                    } catch {
    
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
        
        task.resume()
    }
    
   
}

