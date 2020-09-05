//
//  TermsProfileVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class TermsProfileVC: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()

    }
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }    }
}
