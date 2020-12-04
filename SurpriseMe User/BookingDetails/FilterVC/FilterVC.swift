//
//  FilterVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 28/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var viewBorderRound: UIView!
    @IBOutlet weak var viewDash1: UIView!
    @IBOutlet weak var viewDash2: UIView!
    @IBOutlet weak var viewDash3: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Mark: UIView topborder round
        self.viewBorderRound.roundCorners(corners: [.topLeft, .topRight,], radius: 20)
    }
    
    @IBAction func btnFilterBookingOnPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


