//
//  LoaderVC.swift
//  SurpriseMe User
//
//  Created by NetScape Labs on 11/6/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderVC: UIViewController {
    
    
    @IBOutlet var viewActivityIndicator: NVActivityIndicatorView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        viewActivityIndicator.startAnimating()
    }
}
