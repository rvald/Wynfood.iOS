//
//  DetailViewController.swift
//  Wynfood
//
//  Created by craftman on 5/16/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var infoPanel: InfoPanel!
    var reviewsView: ReviewsView!
    var messageView: MessageView!
    
    var resturantService: RestaurantService! 
    var locationService: LocationService!
    let authService = AuthenticationService()
    
    var rating: Int!
    var reviews: [Rating]!
    var restaurant: Restaurant! = nil
    
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callRequest), name: Notification.Name("WynfoodCallRequestNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(directionRequest), name: Notification.Name("WynfoodDirectionRequestNotification"), object: nil)
        
        title = "Wynfood"
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        let barItemImage = UIImage(named: "profile")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: barItemImage, style: .plain, target: self, action: #selector(profileButtonTap))
        
        infoPanel = InfoPanel(frame: CGRect.zero)
        reviewsView = ReviewsView(frame: CGRect.zero)
        messageView = MessageView(frame: CGRect.zero)
        
        infoPanel.rating = rating
        infoPanel.reviewLabel.text = "\(reviews.count) reviews"
        
        reviewsView.ratings = reviews
        
        setupViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        infoPanel.nameLabel.text = restaurant?.name
        infoPanel.addressLabel.text = restaurant?.address
        infoPanel.cuisineLabel.text = restaurant?.cuisine
        
        if let restaurant = resturantService.distanceForRestaurant(name: restaurant.name) {
            
            infoPanel.distanceLabel.text = "\(restaurant.distance) mi"
            
        } else {
            
            let destination = locationService.createDestinationLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
            
            locationService.distanceInMilesToDestination(destination: destination, name: restaurant.name, completion: { (miles) in
                
                self.infoPanel.distanceLabel.text = "\(miles) mi"
                
            })
        }
    }
    
    // MARK: - Views
    let sectionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Reviews"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Add Review", for: .normal)
        button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Methods
    func callRequest() {
        let number = dialNumber(number: restaurant.phone)
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func dialNumber(number: String) -> URL {
        let number = formatPhoneNumber(number: number)
        return URL(string: "telprompt://\(number))")!
    }
    
    func formatPhoneNumber(number: String) -> String {
        
        let numberWithOutSeparator = number.replacingOccurrences(of: "-", with: "")
        let numberWithOutSpace = numberWithOutSeparator.replacingOccurrences(of: " ", with: "")
        let numberWithOutFirstParem = numberWithOutSpace.replacingOccurrences(of: "(", with: "")
        let numberWithOutLastParem = numberWithOutFirstParem.replacingOccurrences(of: ")", with: "")
        
        return numberWithOutLastParem
    }
    
    func directionRequest() {
       
        let destination = locationService.createDestinationLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        locationService.lauchMapDirections(destination: destination, name: restaurant.name)
    }
    
    
    // MARK: - Actions
    func addButtonTap() {
        
        if authService.isUserLoggedIn() {
            
            let addReviewViewController = CreateReviewViewController()
            addReviewViewController.restaurantId = restaurant.id
            addReviewViewController.restaurantName = restaurant.name
            
            present(addReviewViewController, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Wynfood", message: "Must be logged in to post a review.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { ( _ ) in

                self.present(SignInViewController(), animated: true, completion: nil)
            })

            alert.addAction(action)

            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func profileButtonTap() {
        
        if authService.isUserLoggedIn() {
            
            present(ProfileViewController(), animated: true, completion: nil)
            
        } else {
            
            present(SignInViewController(), animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        
        view.addSubview(sectionLabel)
        view.addSubview(addButton)
        view.addSubview(infoPanel)
        
        if reviews.count == 0 {
            
            view.addSubview(messageView)
            
            // message view constraints
            view.addConstraint(NSLayoutConstraint(item: messageView, attribute: .top, relatedBy: .equal, toItem: addButton, attribute: .bottom, multiplier: 1.0, constant: 24.0))
            
            view.addConstraint(NSLayoutConstraint(item: messageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -24.0))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": messageView]))
        
        } else {
            
            view.addSubview(reviewsView)
            
            // review view constraints
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reviewsView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-7-[v0]-13-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reviewsView, "v1": sectionLabel]))
        }
        
        
        // info panel view constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": infoPanel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": infoPanel]))
        
        // section label constraints
        view.addConstraint(NSLayoutConstraint(item: sectionLabel, attribute: .top, relatedBy: .equal, toItem: infoPanel, attribute: .bottom, multiplier: 1.0, constant: 24.0))
        
        view.addConstraint(NSLayoutConstraint(item: sectionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        // add button constraints
        view.addConstraint(NSLayoutConstraint(item: addButton, attribute: .centerY, relatedBy: .equal, toItem: sectionLabel, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        
        view.addConstraint(NSLayoutConstraint(item: addButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
    }
    
    

}
