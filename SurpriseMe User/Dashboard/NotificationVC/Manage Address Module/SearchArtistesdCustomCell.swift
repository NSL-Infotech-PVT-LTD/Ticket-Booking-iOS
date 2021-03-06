//
//  SearchArtistesdCustomCell.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Cosmos

class SearchArtistesdCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var brandNewLbl: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var cosmoView: CosmosView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
