//
//  BookingDetailVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 28/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class BookingDetailVC: UIViewController {

    @IBOutlet weak var viewDash1: UIView!
    @IBOutlet weak var viewDash2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


