//
//  ScheduleBookingVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 13/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ScheduleBookingVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnDigitalAction: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    
    //MARK:- Variables -
    var isSelected = Bool()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
    }
    
   @IBAction func btnLiveActionValue(_ sender: UIButton) {
        self.btnLiveShowAction(self.btnLive)
      }
    
    @IBAction func btnDigitalActiojnValue(_ sender: UIButton) {
        self.btnDigitalAction(self.btnDigitalAction)
    }
    
    //MARK:- Custom button Action -
    @IBAction func btnLiveShowAction(_ sender: UIButton) {
        btnLive.setImage(UIImage(named: "Ellipse 114"), for: .normal)
        btnDigitalAction.setImage(UIImage(named: "play.png"), for: .normal)
        selectedType = "live"
        isSelected = true
    }
    
    @IBAction func btnDigitalAction(_ sender: UIButton) {
        btnLive.setImage(UIImage(named: "play.png"), for: .normal)
        btnDigitalAction.setImage(UIImage(named: "Ellipse 114"), for: .normal)
        selectedType = "digital"
        isSelected = true
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func btnProceedAction(_ sender: UIButton) {
        if isSelected == false{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Please select booking type", btnOkTitle: "Done") {
            }
        }else{
              self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)
        }
    }
    
}
