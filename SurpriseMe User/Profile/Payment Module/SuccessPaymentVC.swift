//
//  SuccessPaymentVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 11/11/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SuccessPaymentVC: UIViewController {
    
    var gameTimer: Timer?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)

    }
    
    
    @objc func runTimedCode() {
         let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
                                   let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
                                   
                                   
                                   controller.isComingFrom = "Payment"
                                   
                                   controller.bookingID = bookingPaymentID ?? 0
                                   controller.hidesBottomBarWhenPushed = true
                                   
                                   //                                                        let bookingDict = self.arrayBookingList[indexPath.row]
                                   
                                   //                                                        controller.bookingID = bookingDict.id ?? 0
                                   self.navigationController?.pushViewController(controller, animated: true)
                                   
                                   bookingPaymentID  = 0
    }
    

}
