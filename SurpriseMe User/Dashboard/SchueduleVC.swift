//
//  SchueduleVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 28/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class SchueduleVC: UIViewController {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var btnDigital: UIButton!
    @IBOutlet weak var lblTittelSehudeule: UILabel!
    @IBOutlet weak var lblSubTittelSehuedule: UILabel!
    @IBOutlet weak var lblLiveShowBooking: UILabel!
    @IBOutlet var lblLiveDetail: UILabel!
    @IBOutlet weak var lblDigitalShow: UILabel!
    @IBOutlet var lblDigitalDetail: UILabel!
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet var btnBookNowLive: UIButton!
    @IBOutlet var btnBookNowDigital: UIButton!
    
    //MARK:- Variable -
    var isSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLocalization()
    }
    
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    func setLocalization(){
        self.lblTittelSehudeule.text = "select_booking_Title".localized()
        self.lblSubTittelSehuedule.text = "Booking_Edit".localized()
        self.lblLiveShowBooking.text = "live_booking".localized()
        self.lblDigitalShow.text = "digital_booking".localized()
        self.btnProcess.setTitle("Proceed".localized(), for: .normal)
        self.btnBookNowLive.setTitle("book_now".localized(), for: .normal)
        self.btnBookNowDigital.setTitle("book_now".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // lblTittelSehudeule.text = "check_availabilty".localized()
       // lblSubTittelSehuedule.text = "check_availabilty".localized()
        //lblLiveShowBooking.text = "live_booking".localized()
//        lblLiveDetail.text = "live_booking_detail".localized()
//        lblDigitalShow.text = "digital_booking".localized()
//        lblDigitalDetail.text = "digital_booking_detail".localized()
//        btnProcess.setTitle("Proceed".localized(), for: .normal)
//        btnBookNowLive.setTitle("book_now".localized(), for: .normal)
//        btnBookNowDigital.setTitle("book_now".localized(), for: .normal)
//       self.btnDigital.backgroundColor = UIColor.white
        //MARK: When View appear btn are reset
//        self.btnOffline.backgroundColor = UIColor.white
      
        if  whicShowTypeDigital == false{
            self.btnBookNowLive.isUserInteractionEnabled = false
            
            
            print("digital")
            
            self.btnBookNowLive.backgroundColor = UIColor.lightGray
            self.btnBookNowDigital.isUserInteractionEnabled = true
                       self.btnBookNowLive.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255, alpha: 1)
            
        }else{
            print("live")

            self.btnBookNowLive.isUserInteractionEnabled = true
                       self.btnBookNowDigital.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                       self.btnBookNowDigital.isUserInteractionEnabled = false
                                  self.btnBookNowLive.backgroundColor = UIColor.lightGray
        }
        
        
        
        
        //MARK: When View appear btn are reset
    }
    
    @IBAction func btnOfflineOnPress(_ sender: UIButton) {
        
        
            self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)
        
     isSelected = true
    

    }
    
    @IBAction func btnDigitalOnPress(_ sender: UIButton){
        
        
       
                 self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)
        
        selectedType = "digital"

}

    @IBAction func btnProceedOnPress(_ sender: UIButton) {
        
       
    }
}
