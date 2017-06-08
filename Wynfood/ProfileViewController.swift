//
//  ProfileViewController.swift
//  Wynfood
//
//  Created by craftman on 5/18/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    let reviewView = ReviewsView()
   
    let networkingService = NetworkingService()
    let authService = AuthenticationService()
    var ratingService = RatingService()

    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        userNameLabel.text = authService.getUserName()
        
        networkingService.getRatings { (json) in
            
            self.ratingService.parseJsonData(jsonObject: json)
            self.reviewView.ratings = self.ratingService.ratingsForUser(userName: self.authService.getUserName())
            
            DispatchQueue.main.async {
                self.reviewView.reviewsCollectionView.reloadData()
            }
        }
        
        setupViews()
        
    }
    
    // MARK: - Views
    let userNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "UserName"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let sectionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Reviews"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let closeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let logOutButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Methods
    
    func closeButtonTap() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func logOutButtonTap() {
        
        if Auth.auth().currentUser != nil {
            
            do {
                try! Auth.auth().signOut()
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        
        view.addSubview(reviewView)
        view.addSubview(userNameLabel)
        view.addSubview(closeButton)
        view.addSubview(sectionLabel)
        view.addSubview(logOutButton)
        
        // close button constraints
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 40.0))
        
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        // log out button constraints
        view.addConstraint(NSLayoutConstraint(item: logOutButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 40.0))
        
        view.addConstraint(NSLayoutConstraint(item: logOutButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        // username constraints
        view.addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: closeButton, attribute: .bottom, multiplier: 1.0, constant: 48.0))
        
        view.addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        
        // section label constraints
        view.addConstraint(NSLayoutConstraint(item: sectionLabel, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1.0, constant: 24.0))
        
        view.addConstraint(NSLayoutConstraint(item: sectionLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        // review view constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reviewView]))
        
        view.addConstraint(NSLayoutConstraint(item: reviewView, attribute: .top, relatedBy: .equal, toItem: sectionLabel, attribute: .bottom, multiplier: 1.0, constant: 7.0))
        
        view.addConstraint(NSLayoutConstraint(item: reviewView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -13.0))
        
    }

}
