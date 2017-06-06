//
//  InfoPanel.swift
//  Wynfood
//
//  Created by craftman on 5/17/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit
import MapKit

class InfoPanel: UIView {
    
    // MARK: - Properties
    let directionRequestNotification = Notification.Name("WynfoodDirectionRequestNotification")
    let callRequestNotification = Notification.Name("WynfoodCallRequestNotification")
    
    private var buttons = [UIButton]()
    private var locationService = LocationService()
    var rating: Int! {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    // MARK: - View Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 5.0
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Wynwood Bar"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addressLabel: UILabel = {
        
        let label = UILabel()
        label.text = "231 North East 3rd Ave, Miami, FL 33127"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let cuisineLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Latin"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let reviewLabel: UILabel = {
        
        let label = UILabel()
        label.text = "(5 Reviews)"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let distanceLabel: UILabel = {
        
        let label = UILabel()
        label.text = "2.1 mi"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let directionsButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Directions", for: .normal)
        button.setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(directionButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let callButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Call", for: .normal)
        button.setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(callButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Actions
    func callButtonTap() {
        
        NotificationCenter.default.post(name: callRequestNotification, object: nil)
    }
    
    func directionButtonTap() {
        
        NotificationCenter.default.post(name: directionRequestNotification, object: nil)
    }
    
    
    // MARK: - Methods
    private func createRatingButtons() {
        
        for index in 0..<5 {
            
            let button = UIButton()
            button.setImage(UIImage(named: "star_empty"), for: .normal)
            button.setImage(UIImage(named: "star_fill"), for: .selected)
            button.setImage(UIImage(named: "star_fill"), for: [.highlighted, .selected])
            button.adjustsImageWhenHighlighted = false
            button.tag = index
            button.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(button)
            
            buttons.append(button)
        }
    }

    
    func updateButtonSelectionStates() {
        
        for (index, button) in buttons.enumerated() {
            
            button.isSelected = index < rating
        }
    }
    
    func setupViews() {
      
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(cuisineLabel)
        addSubview(reviewLabel)
        addSubview(distanceLabel)
        addSubview(directionsButton)
        addSubview(callButton)
        
        createRatingButtons()
        
        // name label constraints
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12.0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 13.0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -13.0))
        
        // address label constraints
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 13.0))
        addConstraint(NSLayoutConstraint(item: addressLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -13.0))
        
        // cuisine label constraints
        addConstraint(NSLayoutConstraint(item: cuisineLabel, attribute: .top, relatedBy: .equal, toItem: addressLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraint(NSLayoutConstraint(item: cuisineLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 13.0))
        
        // review label constraints
        addConstraint(NSLayoutConstraint(item: reviewLabel, attribute: .top, relatedBy: .equal, toItem: addressLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        addConstraint(NSLayoutConstraint(item: reviewLabel, attribute: .leading, relatedBy: .equal, toItem: cuisineLabel, attribute: .trailing, multiplier: 1.0, constant: 13.0))
        
        // distance label constraints
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .centerY, relatedBy: .equal, toItem: cuisineLabel, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -13.0))
        
        // directions button constraints
        addConstraint(NSLayoutConstraint(item: directionsButton, attribute: .centerY, relatedBy: .equal, toItem: callButton, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        addConstraint(NSLayoutConstraint(item: directionsButton, attribute: .trailing, relatedBy: .equal, toItem: callButton, attribute: .leading, multiplier: 1.0, constant: -12.0))
        
        // call button constraints
        addConstraint(NSLayoutConstraint(item: callButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -13.0))
        addConstraint(NSLayoutConstraint(item: callButton, attribute: .top, relatedBy: .equal, toItem: distanceLabel, attribute: .bottom, multiplier: 1.0, constant: 7.0))
        
        // rating buttons constraints
        addContraintsToRatingButtons(ratingButtons: buttons)
    }
    
    private func addContraintsToRatingButtons(ratingButtons: [UIButton]) {
        
        for (index, button) in ratingButtons.enumerated() {
            
            if index == 0 {
                
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-12-[v0]-13-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": cuisineLabel]))
            
            } else {
                
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": ratingButtons[button.tag - 1]]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-12-[v0]-13-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": cuisineLabel]))
            }
        }
    }

}
