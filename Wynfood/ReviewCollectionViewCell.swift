//
//  ReviewCollectionViewCell.swift
//  Wynfood
//
//  Created by craftman on 5/18/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var buttons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    
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
        label.text = "Joe Appleseed"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let textLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Great meal. Excellent service."
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let createdLabel: UILabel = {
        
        let label = UILabel()
        label.text = "1 day"
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: - Methods
    func setupViews() {
        
        addSubview(nameLabel)
        addSubview(textLabel)
        addSubview(createdLabel)
        
        createRatingButtons()
        
        // name label constraints
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 13.0))
        
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 12.0))
        
        // text label constraints
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 13.0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        
        // created label constraints
        addConstraint(NSLayoutConstraint(item: createdLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 13.0))
        
        addConstraint(NSLayoutConstraint(item: createdLabel, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0))
        
        addContraintsToRatingButtons(ratingButtons: buttons)
        
    }
    
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
    
    private func updateButtonSelectionStates() {
        
        for (index, button) in buttons.enumerated() {
            
            button.isSelected = index < rating
        }
    }
    
    private func addContraintsToRatingButtons(ratingButtons: [UIButton]) {
        
        for (index, button) in ratingButtons.enumerated() {
            
            if index == ratingButtons.count - 1 {
                
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-13-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[v0]-12-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": textLabel]))
                
            } else {
                
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-12-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": ratingButtons[button.tag + 1]]))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[v0]-12-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": textLabel]))
                
            }
        }
    }
      
}
