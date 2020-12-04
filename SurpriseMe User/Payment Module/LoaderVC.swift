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
    
    var gameTimer: Timer?

    @IBOutlet var viewActivityIndicator: NVActivityIndicatorView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        viewActivityIndicator.startAnimating()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)

    }
    
    
    @objc func runTimedCode() {
         let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                                   let controller = storyboard.instantiateViewController(withIdentifier: "SuccessPaymentVC") as! SuccessPaymentVC
                                   
                                   
//                                   controller.isComingFrom = "Payment"
//
//                                   controller.bookingID = bookingPaymentID ?? 0
                                   controller.hidesBottomBarWhenPushed = true
                                   
                                   //                                                        let bookingDict = self.arrayBookingList[indexPath.row]
                                   
                                   //                                                        controller.bookingID = bookingDict.id ?? 0
                                   self.navigationController?.pushViewController(controller, animated: true)
                                   
//                                   bookingPaymentID  = 0
    }
    

}
