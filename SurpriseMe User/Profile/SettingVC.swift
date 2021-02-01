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
    @IBOutlet weak var lblChngeLanguage: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblTermsAndConditions: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewChangeLaguage: UIView!
    @IBOutlet weak var viewChangeLagContainer: UIView!
    
    
    
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalisation()
        self.viewChangeLaguage.isHidden = true
        self.viewChangeLagContainer.isHidden = true
    }
    
    func setLocalisation()  {
        self.lblChngeLanguage.text = "CHANGE_LANG".localized()
        self.lblAbout.text = "ABOUT_US".localized()
        self.lblPrivacyPolicy.text = "PRIVACY_POLICY".localized()
        self.lblTermsAndConditions.text = "TERMSACONDITION".localized()
        btnBack.setTitle("back".localized(), for: .normal)
    }
    
    @objc func handletapChangeLag(_ sender: UITapGestureRecognizer? = nil) {
        isCameFromCL = "Setting"
//        self.viewChangeLaguage.isHidden = false
//        self.viewChangeLagContainer.isHidden = false
//        
//       
//        
//        
//        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: .linear)
//        transition.type = CATransitionType(rawValue: "flip")
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromTop
//        viewChangeLaguage.layer.add(transition, forKey: kCATransition)
        
        
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
    
    @IBAction func btnBackActionLange(_ sender: UIButton) {
        self.viewChangeLaguage.isHidden = true
        self.viewChangeLagContainer.isHidden = true
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = CATransitionType(rawValue: "flip")
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        //viewChangeLagContainer.layer.removeAnimation(forKey: kCATransition)
        viewChangeLaguage.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
