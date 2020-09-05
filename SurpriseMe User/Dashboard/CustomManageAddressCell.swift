//
//  CustomManageAddressCell.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 30/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class CustomManageAddressCell: UITableViewCell {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var addressTypeImg: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
