//
//  MessageView.swift
//  Wynfood
//
//  Created by craftman on 5/23/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

class MessageView: UIView {

    
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
    let messageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Restaurant has no reviews, enjoyed your dining experience let us know. Add your own review."
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: - Methods
    func setupViews() {
        
        addSubview(messageLabel)
        
        // message constraints
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 1.0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 13.0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -13.0))
 
    }

}
