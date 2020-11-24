//
//  SuccessPaymentVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 11/11/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SuccessPaymentVC: UIViewController {
    
    //MARK:- Variables -
    var gameTimer: Timer?

    //MARK:- Outlets -
    @IBOutlet weak var lblPayMentStatus: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if idealPaymentFailed == true{
            lblPayMentStatus.text = "Payment Failed!"
             statusIcon.image = UIImage.init(named: "failed")
lblDesc.text = "You can pay again from booking detail Screen"
            viewContainer.backgroundColor = UIColor.init(red: 204/255, green: 47/255, blue: 40/255, alpha: 1)
            
            
        }else{
            lblPayMentStatus.text = "Payment Done"
            statusIcon.image = UIImage.init(named: "success")
            lblDesc.text = "Hurray you can get ready for show"
             viewContainer.backgroundColor = UIColor.init(red: 240/255, green: 0/255, blue: 87/255, alpha: 1)
      }
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
