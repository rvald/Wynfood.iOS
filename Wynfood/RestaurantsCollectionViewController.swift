//
//  RestaurantsCollectionViewController.swift
//  Wynfood
//
//  Created by craftman on 5/25/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RestaurantsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, LocationServiceDelegate{
    
    // MARK: - Properties
    var restaurants: [Restaurant]!
    let networkingService = NetworkingService()
    var locationService: LocationService! = nil
    var restaurantService: RestaurantService! = nil
    let authService = AuthenticationService()
    var ratings: [Rating]!
    var ratingService = RatingService()
    

    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        locationService.locationDelegate = self

        // Register cell classes
        self.collectionView!.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // collection view style
        collectionView?.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        collectionView?.contentInset = UIEdgeInsetsMake(24.0, 0.0, 24.0, 0.0)
        
        // navigation bar title
        title = "Wynfood"
        
        // style navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // custom back button title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // add navigation bar item
        let profileBarItemImage = UIImage(named: "profile")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileBarItemImage, style: .plain, target: self, action: #selector(profileButtonTapped))
        
        let searchBarItemImage = UIImage(named: "search")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: searchBarItemImage, style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkingService.getRatings { (json) in
            self.ratingService.parseJsonData(jsonObject: json)
            self.ratings = self.ratingService.allRatings()
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        

    }

  
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RestaurantCollectionViewCell
        
        let restaurant = restaurants[indexPath.item]
        
        cell.nameLabel.text = restaurant.name
        cell.descriptionLabel.text = restaurant.description
        cell.cuisineLabel.text = restaurant.cuisine
        
        if ratings == nil {
            cell.reviewLabel.text = ""
            
            
        } else {
    
            cell.reviewLabel.text = "\(ratingService.ratingsForRestaurant(ratings: ratings, id: restaurant.id).count)  reviews"
        }
        
        
        if locationService.currentLocation == nil {
            
            cell.distanceLabel.text = ""
        
        } else {
            
            if let restaurant = restaurantService.distanceForRestaurant(name: restaurant.name) {
                
                cell.distanceLabel.text = "\(restaurant.distance) mi"
                
            } else {
                
                let destination = locationService.createDestinationLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
                
                locationService.distanceInMilesToDestination(destination: destination, name: restaurant.name, completion: { (miles) in
                    
                    cell.distanceLabel.text = "\(miles) mi"
                    
                    var aRestaurant = restaurant
                    aRestaurant.distance = miles
                    
                    self.restaurantService.cacheDistance(restaurant: aRestaurant)
                    
                })
            }
        }
        
        cell.layer.cornerRadius = 5
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let restaurant = restaurants[indexPath.item]
        let count = ratingService.ratingsForRestaurant(ratings: ratings, id: restaurant.id).count
        let total = ratingService.ratingValue(ratings: ratings, id: restaurant.id)
        
        let detailViewController = DetailViewController()
        detailViewController.restaurant = restaurant
        detailViewController.locationService = locationService
        detailViewController.resturantService = restaurantService
        
        if count == 0 {
            
            detailViewController.rating = 0
            
        } else {
           
            detailViewController.rating = total / count
        }
        
        detailViewController.reviews = ratingService.ratingsForRestaurant(ratings: ratings, id: restaurant.id)

        navigationController?.pushViewController(detailViewController, animated: true)
    }

    // MARK: - UICollectionViewFlowDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = UIScreen.main.bounds.size.width - 40
        let restaurant = restaurants[indexPath.row]

        let size = CGSize(width: width, height: 1000.00)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let titleFrame = NSString(string: restaurant.name).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)], context: nil)

        let descriptionFrame = NSString(string: restaurant.description).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)], context: nil)

        let cuisineFrame = NSString(string: restaurant.cuisine).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)], context: nil)

        let height = (titleFrame.height + descriptionFrame.height + cuisineFrame.height) + 60.0

        return CGSize(width: width, height: height)
    }
    
    // MARK: - LocationServiceDelegate
    func locationServiceDidFailed(error: String) {
        presentAlertMessage(message: error)
    }
    
    func locationServiceRestricted(message: String) {
        presentAlertMessage(message: message)
    }
    
    func didUpdateCurrentLocation() {
        collectionView?.reloadData()
    }
    
    // MARK: - Methods
    func presentAlertMessage(message: String) {
        
        let alertController = UIAlertController(title: "Location Service", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    func profileButtonTapped() {
        
        if authService.isUserLoggedIn() {
            present(ProfileViewController(), animated: true, completion: nil)
        
        } else {
            present(SignInViewController(), animated: true, completion: nil)
        }
    }
    
    func searchButtonTapped() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
        
    }

}
