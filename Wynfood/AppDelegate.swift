//
//  AppDelegate.swift
//  Wynfood
//
//  Created by craftman on 4/18/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let restaurantsCollectionVC = RestaurantsCollectionViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
    let searchViewController = SearchViewController()
    let locationService  = LocationService()
    let restaurantService = RestaurantService()
    let networkingService = NetworkingService()
    let authService = AuthenticationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        
        let navigationController = UINavigationController(rootViewController: restaurantsCollectionVC)
        navigationController.navigationBar.barTintColor = UIColor.white
        
        restaurantService.parseData()
        
        restaurantsCollectionVC.restaurants = restaurantService.allRestaurants()
        restaurantsCollectionVC.locationService = locationService
        restaurantsCollectionVC.restaurantService = restaurantService
        
        locationService.restaurantService = restaurantService
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
     
        restaurantService.deleteCache()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        restaurantService.deleteCache()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
        restaurantService.deleteCache()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        authService.logOut()
        
    }


}

