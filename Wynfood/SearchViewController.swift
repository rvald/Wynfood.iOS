//
//  SearchViewController.swift
//  Wynfood
//
//  Created by craftman on 5/26/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

private let cellIdentifier = "Cell"

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var searchResults = [Restaurant]()
    var locationService = LocationService()
    var restaurantService = RestaurantService()
    var ratingService = RatingService()
    var networkingService = NetworkingService()
    var ratings: [Rating]! {
        didSet {
            restaurantsCollectionView.reloadData()
        }
    }
    var restaurants: [Restaurant] {
        return list()
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingService.getRatings { (json) in
            self.ratingService.parseJsonData(jsonObject: json)
            self.ratings = self.ratingService.allRatings()
        }
   
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)

        title = "Wynfood"

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        // custom back button title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        setupViews()
    }

    // MARK: - Views
    lazy var searchBar: UISearchBar = {

        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "Search Cuisine..."
        bar.barTintColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        bar.backgroundImage = UIImage()
        bar.showsCancelButton = true
        bar.translatesAutoresizingMaskIntoConstraints = false

        return bar
    }()

    lazy var restaurantsCollectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)

        layout.minimumLineSpacing = 16.0

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - Methods
    func setupViews() {

        view.addSubview(searchBar)
        view.addSubview(restaurantsCollectionView)


        // search bar constraints
        view.addConstraint(NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": searchBar]))

        // restaurant tableview constraints
        view.addConstraint(NSLayoutConstraint(item: restaurantsCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))

        view.addConstraint(NSLayoutConstraint(item: restaurantsCollectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))

        view.addConstraint(NSLayoutConstraint(item: restaurantsCollectionView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1.0, constant: 24.0))

        view.addConstraint(NSLayoutConstraint(item: restaurantsCollectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -24.0))

    }
    
    func list() -> [Restaurant] {
        
        restaurantService.parseData()
        return restaurantService.allRestaurants()
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)as! RestaurantCollectionViewCell

        let restaurant = searchResults[indexPath.item]

        cell.nameLabel.text = restaurant.name
        cell.cuisineLabel.text = restaurant.cuisine
        cell.descriptionLabel.text = restaurant.description
        
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

        cell.layer.cornerRadius = 5.0

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        searchBar.resignFirstResponder()

        let restaurant = searchResults[indexPath.item]
        
        let detailViewController = DetailViewController()
        detailViewController.restaurant = restaurant
        detailViewController.locationService = locationService
        detailViewController.resturantService = restaurantService
        
        let count = ratingService.ratingsForRestaurant(ratings: ratings, id: restaurant.id).count
        let total = ratingService.ratingValue(ratings: ratings, id: restaurant.id)
        
        if count == 0 {
            detailViewController.rating = 0
            
        } else {
            detailViewController.rating = count / total
        }
        
        detailViewController.reviews = ratingService.ratingsForRestaurant(ratings: ratings, id: restaurant.id)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = UIScreen.main.bounds.size.width - 40
        let restaurant = searchResults[indexPath.row]

        let size = CGSize(width: width, height: 1000.00)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let titleFrame = NSString(string: restaurant.name).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)], context: nil)

        let descriptionFrame = NSString(string: restaurant.description).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)], context: nil)

        let cuisineFrame = NSString(string: restaurant.cuisine).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)], context: nil)

        let height = (titleFrame.height + descriptionFrame.height + cuisineFrame.height) + 60.0


        return CGSize(width: width, height: height)
    }
    
    // MARK: - SearchViewModelDelegate
    func reloadCollectionView() {
        restaurantsCollectionView.reloadData()
    }


    // MARK: - SearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let results = restaurants.filter { $0.cuisine == searchBar.text! }

        if (results.isEmpty) {

            let alertController = UIAlertController(title: "Wynfood", message: "Your search did not have any results.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)

            alertController.addAction(action)

            present(alertController, animated: true, completion: nil)

        } else {

            searchResults = results

            restaurantsCollectionView.reloadData()

            let indexPath = IndexPath(item: 0, section: 0)

            restaurantsCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)

            searchBar.resignFirstResponder()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }

}
