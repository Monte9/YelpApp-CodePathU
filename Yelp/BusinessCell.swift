//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Monte's Pro 13" on 2/3/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var businessCuisinesLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    @IBOutlet weak var businessReviewsLabel: UILabel!
    @IBOutlet weak var businessRatingImageView: UIImageView!
    
    var business : Business! {
        didSet {
            businessNameLabel.text = business.name
            businessImageView.setImageWithURL(business.imageURL!)
            businessAddressLabel.text = business.address
            businessCuisinesLabel.text = business.categories
            businessDistanceLabel.text = business.distance
            businessReviewsLabel.text = "\(business.reviewCount as! Int) Reviews"
            businessRatingImageView.setImageWithURL(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        businessImageView.layer.cornerRadius = 5
        businessImageView.clipsToBounds = true
        
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
