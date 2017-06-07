//
//  RatingService.swift
//  Wynfood
//
//  Created by craftman on 5/23/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation

struct RatingService {
    
    // MARK: - Properties
    private var ratings = [Rating]()
    
    
    // MARK: - Methods
    mutating func parseJsonData(jsonObject: [Dictionary<String, AnyObject>]) {
        
        for object in jsonObject {
            
            let restaurantId = object["restaurantId"] as! Int
            let userName = object["userName"] as! String
            let text = object["text"] as! String
            let value = object["value"] as! Int
            let created = object["created"]
            
            let rating = Rating(userName: userName, restaurantId: restaurantId, text: text, value: value, created: created)
         
            ratings.append(rating)
        }
    }
    
    
    func ratingsForRestaurant(ratings: [Rating], id: Int) -> [Rating] {
        
        var resRatings = [Rating]()
        
        for rating in ratings {
            
            if rating.restaurantId == id {
                
                let duplicate = resRatings.contains(where: { $0.text == rating.text })
                
                if duplicate == false {
                    
                    resRatings.append(rating)
                }
            }
        }
        
        return resRatings
    }
    
    func ratingsForUser(ratings: [Rating], userName: String) -> [Rating] {
        
        var resRatings = [Rating]()
        
        for rating in ratings {
            
            if rating.userName == userName {
                
                resRatings.append(rating)
            }
        }
        
        return resRatings
    }
    
    
    func ratingValue(ratings: [Rating], id: Int) -> Int {
        
        var total = 0
        
        let resRatings = ratingsForRestaurant(ratings: ratings, id: id)
        
        if resRatings.count == 0 {
            
            return total
        
        } else {
            
            for rat in resRatings {
                
                total += rat.value
            }
        }
        
        return total
    }
    
    func allRatings() -> [Rating] {
        return ratings
    }
}
