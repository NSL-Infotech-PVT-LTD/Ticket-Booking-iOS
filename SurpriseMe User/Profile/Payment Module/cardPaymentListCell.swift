//
//  cardPaymentListCell.swift
//  Lanaguage Change
//
//  Created by Loveleen Kaur Atwal on 06/11/20.
//

import UIKit

class cardPaymentListCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblCardDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExpireMonth: UILabel!
    @IBOutlet weak var txtCVV: UITextField!
    
    
    @IBOutlet var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
