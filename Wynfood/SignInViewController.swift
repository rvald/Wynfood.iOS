//
//  SignInViewController.swift
//  Wynfood
//
//  Created by craftman on 6/2/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    var logInView: LogInView!
    var registerView: RegisterView!

    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dissmisView), name: Notification.Name("WynfoodDismissViewNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentAlertView), name: Notification.Name("WynfoodPresentAlertNotification"), object: nil)
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        logInView = LogInView(frame: CGRect.zero)
        registerView = RegisterView(frame: CGRect.zero)

        setupView()
    }
    
    // MARK: - Views
    let closeButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        
        let control = UISegmentedControl(items: ["Log In", "Register"])
        control.addTarget(self, action: #selector(segementedControlTapped), for: .valueChanged)
        control.tintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        control.backgroundColor = UIColor.white
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    // MARK: - Methods
    func setupView() {
        
        view.addSubview(closeButton)
        view.addSubview(segmentedControl)
        view.addSubview(registerView)
        view.addSubview(logInView)
        
        registerView.isHidden = true
        
        
        // close button constraints
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 40.0))
        
        view.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        // segmented control constraints
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-88-[v0(36)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": segmentedControl]))

        
        view.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        // log in view constraints
        view.addConstraint(NSLayoutConstraint(item: logInView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: logInView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-13-[v0]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": logInView, "v1": segmentedControl]))
        
        // register view constraints
        view.addConstraint(NSLayoutConstraint(item: registerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: registerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-13-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": registerView, "v1": segmentedControl]))
        
        
    }
    
    func presentAlertView(notification: NSNotification) {
        
        let message = notification.userInfo?["message"] as! String
        let alert = UIAlertController(title: "Wynfood", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func dissmisView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func closeButtonTap() {
        
        dismiss(animated: true, completion: nil)
    }

   
    func segementedControlTapped(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.logInView.isHidden = true
                
            }, completion: { (true) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.registerView.isHidden = false
                })
            })
        
        } else if sender.selectedSegmentIndex == 0 {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.registerView.isHidden = true
                
            }, completion: { (true) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.logInView.isHidden = false
                })
            })
        }
    }



}
