//
//  BookingTableViewCell.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import Cosmos

class BookingTableViewCell: UITableViewCell {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewBookingBorderDash: UIView!
    @IBOutlet weak var btnseeAllDetails: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var cosmoView: CosmosView!
    @IBOutlet weak var userImgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookDate: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    
    @IBOutlet weak var tittelView: UIView!
    @IBOutlet weak var lblBookingStatus: UILabel!
    
    @IBOutlet weak var lblSkill: UILabel!
    @IBOutlet weak var lblRatedAddress: UILabel!
    @IBOutlet weak var viewCosmo: CosmosView!
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tittelView.roundCorners(corners: [.bottomLeft,.topRight], radius: 20.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
