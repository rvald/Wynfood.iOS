//
//  CreateReviewViewController.swift
//  Wynfood
//
//  Created by craftman on 5/18/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

let didPostReviewNotification = Notification.Name("WynfoodDidPostReviewNotification")

class CreateReviewViewController: UIViewController, UITextViewDelegate{
    
    // MARK: - Properties
    private var buttons = [UIButton]()
    var networkingService = NetworkingService()
    let authService = AuthenticationService()
    var restaurantId = 0
    var restaurantName = ""
    var userId = ""
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenTap)))
        
        nameLabel.text = restaurantName
        
        setupViews()
    }
    
    // MARK: - Views
    let closeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Wynwood Bar"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var textView: UITextView = {
        
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let postButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Post Review", for: .normal)
        button.addTarget(self, action: #selector(postReview), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
   
    // MARK: - Methods
    func screenTap() {
        
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
    
    func postReview() {
        
        if textView.isFirstResponder {
            
            textView.resignFirstResponder()
        }
        
        if rating == 0 || textView.text.characters.count < 3 {
            
            let alertController = UIAlertController(title: "Wynfood", message: "Invalid rating or review.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            
            
            
            let rating = Rating(userName: authService.getUserName(), restaurantId: restaurantId, text: textView.text, value: self.rating, created: nil)
            
            networkingService.postRating(rating: rating)
            
            
            let alertController = UIAlertController(title: "Wynfood", message: "We appreciate your feedback.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    func closeButtonTap() {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func createRatingButtons() {
        
        for index in 0..<5 {
            
            let button = UIButton()
            button.setImage(UIImage(named: "star_empty_lg"), for: .normal)
            button.setImage(UIImage(named: "star_fill_lg"), for: .selected)
            button.setImage(UIImage(named: "star_fill_lg"), for: [.highlighted, .selected])
            button.adjustsImageWhenHighlighted = false
            button.tag = index
            button.addTarget(self, action:  #selector(ratingButtonTapped), for: .touchDown)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(button)
            
            buttons.append(button)
        }
    }
    
    private func updateButtonSelectionStates() {
        
        for (index, button) in buttons.enumerated() {
            
            button.isSelected = index < rating
            
        }
    }
    
    @objc private func ratingButtonTapped(button: UIButton) {
        
        rating = button.tag + 1
        
        updateButtonSelectionStates()
    }
    
    private func addContraintsToRatingButtons(ratingButtons: [UIButton]) {
        
        for (index, button) in ratingButtons.enumerated() {
            
            if index == 0 {
                
                let width = view.frame.size.width
                
                if width > 375 {
                    
                    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-70-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
                
                } else {
                    
                    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
                }
                
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": nameLabel]))
                
           } else {
                
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": ratingButtons[button.tag - 1]]))
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button, "v1": nameLabel]))
                
            }
        }
    }
    
    
    func setupViews() {
        
        view.addSubview(closeButton)
        view.addSubview(nameLabel)
        createRatingButtons()
        view.addSubview(textView)
        view.addSubview(postButton)
        
        
        // close button constraints
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 40.0))
        
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        // name label constraints
        view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: closeButton, attribute: .bottom, multiplier: 1.0, constant: 48.0))
        
        view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        
        // textview constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-24-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textView, "v1": buttons[0]]))
        
        // post buttom constraints
        view.addConstraint(NSLayoutConstraint(item: postButton, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 13.0))
        
        view.addConstraint(NSLayoutConstraint(item: postButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        
        addContraintsToRatingButtons(ratingButtons: buttons)
        
    }
    
    // MARK: - TextView
    func textViewDidEndEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
    }
    

}
