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
    @IBOutlet weak var lblDigitalShow: UILabel!
    @IBOutlet weak var btnProcess: UIButton!
    
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
//        self.lblDigitalShow.text = "DIGITAL_SHOW".localized()
//        self.lblTittelSehudeule.text = "SCHEDULE_BOOK".localized()
//        self.lblLiveShowBooking.text = "LIVE_SHOW".localized()
//        self.lblSubTittelSehuedule.text = "SCHEDULE_BOOK_SUB_TITTEL".localized()
//        self.btnProcess.setTitle("PROCEED".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.btnDigital.backgroundColor = UIColor.white //MARK: When View appear btn are reset
//        self.btnOffline.backgroundColor = UIColor.white
      
        
        
        //MARK: When View appear btn are reset
    }
    
    @IBAction func btnOfflineOnPress(_ sender: UIButton) {
        isSelected = true
        selectedType = "live"
//        self.btnOffline.backgroundColor = UIColor(red: 0.21, green: 0.22, blue: 0.43, alpha: 1.00)
//        self.btnDigital.backgroundColor = UIColor.white
                    self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)

    }
    
    @IBAction func btnDigitalOnPress(_ sender: UIButton){
        selectedType = "digital"

               self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)

}

    @IBAction func btnProceedOnPress(_ sender: UIButton) {
        
       
    }
}
