//
//  MessageTableViewCell.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFrindName: UILabel!
    @IBOutlet weak var lblLastMssg: UILabel!
    @IBOutlet weak var imgUserFriend: UIImageView!
    @IBOutlet weak var lblUnreadCount: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
