//
//  ReviewsView.swift
//  Wynfood
//
//  Created by craftman on 5/17/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import UIKit

let identifier = "CellIdentifier"

class ReviewsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var ratings = [Rating]() 
    
    let authService = AuthenticationService()
    

    // MARK: - View Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    lazy var reviewsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        layout.minimumLineSpacing = 16.0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let rating = ratings[indexPath.item]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let startDate = dateFormatter.date(from: rating.created! as! String)!
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM d, yyyy"
        
        let endDate = dateFormatter1.string(from: startDate)
    
        cell.createdLabel.text = endDate
        cell.textLabel.text = rating.text
        cell.rating = rating.value
        cell.nameLabel.text = authService.getUserName()
        
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width - 40
        
        return CGSize(width: width, height: 100.0)
    }
    
    // MARK: - Methods
    func setupViews() {
        
        addSubview(reviewsCollectionView)
        
        // collection view constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reviewsCollectionView]))
        
        addConstraint(NSLayoutConstraint(item: reviewsCollectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 13.0))
        
        addConstraint(NSLayoutConstraint(item: reviewsCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -13.0))
        
    }


}
