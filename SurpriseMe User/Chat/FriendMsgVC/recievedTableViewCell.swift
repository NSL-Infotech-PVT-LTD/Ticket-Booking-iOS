//
//  recievedTableViewCell.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class recievedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblReceiveMsg: UILabel!
    @IBOutlet weak var receiveView: UIView!
    
    
    @IBOutlet weak var receiverImg: UIImageView!
    
    @IBOutlet weak var lblReciveTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
