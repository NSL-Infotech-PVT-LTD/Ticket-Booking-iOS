//
//  CustomSearchArtistCell.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 28/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class CustomSearchArtistCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var imgArtist: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
