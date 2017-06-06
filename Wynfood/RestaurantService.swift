//
//  RestaurantService.swift
//  Wynfood
//
//  Created by craftman on 4/18/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation
import MapKit


class RestaurantService {
    
    // MARK: - Properties
    private var restaurants = [Restaurant]()
    private var restaurantCache = [Restaurant]()
    
    
    // MARK: - Methods
    func restaurant(by id: Int) -> Restaurant {
        
        return restaurants.first(where: { $0.id == id })!
    }
    
    func parseData() {
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "restaurants", ofType: "json")
        
        if let path = path {
            
            let url = URL(fileURLWithPath: path)
            let data = NSData(contentsOf: url)
            
            if let data = data {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data as Data, options: []) as! Dictionary<String, AnyObject>
                    
                    let restaurantObjects = json["restaurants"] as! [Dictionary<String, AnyObject>]
                    
                    for object in restaurantObjects {
                        
                        guard let id = object["id"],
                              let name = object["name"],
                              let address = object["address"],
                              let phone = object["phone"],
                              let cuisine = object["cuisine"],
                              let website = object["website"],
                              let latitude = object["lat"],
                              let longitude = object["long"],
                              let description = object["description"]
                        
                        else {
                            
                            return
                        }
                        
                        
                        let aRestaurant = Restaurant(id: id as! Int,
                                                     name: name as! String,
                                                     address: address as! String,
                                                     phone: phone as! String,
                                                     cuisine: cuisine as! String,
                                                     website: website as! String,
                                                     latitude: latitude as! Double,
                                                     longitude: longitude as! Double,
                                                     distance: "",
                                                     description: description as! String)
                        
                        
                        add(restaurant: aRestaurant)
                        
                    }
                    
                } catch {
                    
                    return
                }
            }
            
        } else {
            
            return
        }
    }
    
    func allRestaurants() -> [Restaurant] {
        
        return restaurants
    }
    
    func add(restaurant: Restaurant) {
        
        restaurants.append(restaurant)
    }
    
    func cacheDistance(restaurant: Restaurant) {
        
        restaurantCache.append(restaurant)
    }
    
    
    func distanceForRestaurant(name: String) -> Restaurant? {
        
        return cachedRestaurants().first(where: { $0.name == name })
    }

    
    func cachedRestaurants() -> [Restaurant] {
        return restaurantCache
    }
    
    func deleteCache() {
        restaurantCache = [Restaurant]()
    }
    
    
}
