//
//  SettingVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Stripe

class SettingVC: UIViewController, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        
        return UIViewController()
    }
    
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewAboutUs: UIView!
    @IBOutlet weak var viewPP: UIView!
    @IBOutlet weak var viewTAndC: UIView!
    
    @IBOutlet weak var viewChangeLag: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addBottomShadow()
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAboutUs(_:)))
        viewAboutUs.addGestureRecognizer(tapviewAboutUs)
        
        let tapviewTAndC = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewTAndC(_:)))
               viewTAndC.addGestureRecognizer(tapviewTAndC)
        
        let tapviewPP = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewPP(_:)))
               viewPP.addGestureRecognizer(tapviewPP)
        
        let tapviewCL = UITapGestureRecognizer(target: self, action: #selector(self.handletapChangeLag(_:)))
        viewChangeLag.addGestureRecognizer(tapviewCL)
        
    }
    
    @objc func handletapChangeLag(_ sender: UITapGestureRecognizer? = nil) {
//    selectedIdentifier = "About Us"
    
    isCameFromCL = "Setting"
    self.presentViewController(viewController : "LanguageVC", value: "Main")

    
    
      }
    
    
       @objc func handletapviewAboutUs(_ sender: UITapGestureRecognizer? = nil) {
        selectedIdentifier = "About Us"
         self.presentViewController(viewController : ViewControllers.TermsProfileVC , value : Storyboard.Main)
        
        self.presentViewController(viewController : "LanguageVC", value: "Main")

        
        
          }
    
    @objc func handletapviewTAndC(_ sender: UITapGestureRecognizer? = nil) {
        
        
     selectedIdentifier = "Terms And Conditions"
      self.presentViewController(viewController : ViewControllers.TermsProfileVC , value : Storyboard.Main)
       }

    @objc func handletapviewPP(_ sender: UITapGestureRecognizer? = nil) {
     selectedIdentifier = "Privacy Policy"
      self.presentViewController(viewController : ViewControllers.TermsProfileVC , value : Storyboard.Main)
       }

    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    
    
    
}
