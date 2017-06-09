//
//  RestaurantCollectionViewCell.swift
//  Wynfood
//
//  Created by craftman on 4/24/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Morgans Restaurant"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let cuisineLabel: UILabel = {
        
        let label = UILabel()
        label.text = "American"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let distanceLabel: UILabel = {
        
        let label = UILabel()
        label.text = "1.3 mi"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Known for gourmet sandwiches, this colorful counter-serve cafe also offers salads & global mains."
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let reviewLabel: UILabel = {
        
        let label = UILabel()
        label.text = "5 Reviews"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    
    // MARK: - Methods
    func setupViews() {
        
        addSubview(nameLabel)
        addSubview(cuisineLabel)
        addSubview(distanceLabel)
        addSubview(descriptionLabel)
        addSubview(reviewLabel)
        
        // name label constraints
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 8.0))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        // cuisine label constraints
        addConstraint(NSLayoutConstraint(item: cuisineLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0))
        
        addConstraint(NSLayoutConstraint(item: cuisineLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8.0))
        
        addConstraint(NSLayoutConstraint(item: cuisineLabel, attribute: .centerY, relatedBy: .equal, toItem: distanceLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // distance label constraints
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0))
        
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
        
        
        // description label constraints
        addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0))
        
        addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: cuisineLabel, attribute: .top, multiplier: 1.0, constant: -10.0))
        
        addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8.0))
        
        addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
        
        // review label constraints
        addConstraint(NSLayoutConstraint(item: reviewLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0))
        
        addConstraint(NSLayoutConstraint(item: reviewLabel, attribute: .leading, relatedBy: .equal, toItem: cuisineLabel, attribute: .trailing, multiplier: 1.0, constant: 13.0))
        
    }
    
}
