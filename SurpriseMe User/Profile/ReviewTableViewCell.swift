//
//  ReviewTableViewCell.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCustomerProfile: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
