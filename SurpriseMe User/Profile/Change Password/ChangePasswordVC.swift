//
//  ChangePasswordVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var lblOldPassword: UILabel!
    
    @IBOutlet weak var btnOldPassword: UIButton!
    
    @IBOutlet weak var btnNewPassword: UIButton!
    
    @IBOutlet weak var btnConfPassword: UIButton!
    
    
    
    
     //MARK:- Variale -
    var modelObject = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addBottomShadow()
        modelObject.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setlocalisation()
    }
    
    func setlocalisation()  {
        self.lblNewPassword.text = "OLD_PASSWORD".localized()
        self.lblConfirmPassword.text = "NEW_PASSWORD".localized()
        self.lblOldPassword.text = "CONFIRM_PASSWORD".localized()
        btnBack.setTitle("back".localized(), for: .normal)
        btnContinue.setTitle("continue".localized(), for: .normal)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    
    @IBAction func btnNewPasswordAction(_ sender: UIButton) {
        
        
        if  sender.isSelected == false{
            sender.isSelected = true
            self.tfPassword.isSecureTextEntry = false
//           btnPasswordConfirm.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }else{
            sender.isSelected = false
            self.tfPassword.isSecureTextEntry = true
            // btnPasswordConfirm.setImage(#imageLiteral(resourceName: "icons8-hide-24"), for: .normal)
        }
        
       
    }
    
    @IBAction func btnOldPassVisibleAction(_ sender: UIButton) {
        
        
        if  sender.isSelected == false{
            sender.isSelected = true
            self.oldPassword.isSecureTextEntry = false
//           btnPasswordConfirm.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }else{
            sender.isSelected = false
            self.oldPassword.isSecureTextEntry = true
            // btnPasswordConfirm.setImage(#imageLiteral(resourceName: "icons8-hide-24"), for: .normal)
        }
       
    }
    
    @IBAction func btnConfPasswordHide(_ sender: UIButton) {
        
        if  sender.isSelected == false{
            sender.isSelected = true
            self.tfConfirmPassword.isSecureTextEntry = false
//           btnPasswordConfirm.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }else{
            sender.isSelected = false
            self.tfConfirmPassword.isSecureTextEntry = true
            // btnPasswordConfirm.setImage(#imageLiteral(resourceName: "icons8-hide-24"), for: .normal)
        }
       
    }
    
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        guard oldPassword.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: "ENTER_OLD_PASSWRD".localized(), btnOkTitle: "DONE".localized()) {
            }
            return
        }
        guard tfPassword.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: "ENTER_YOUR_PASSWRD".localized(), btnOkTitle: "DONE".localized()) {
            }
            return
        }
        let dictParam  = ["old_password":oldPassword.text!,"password":tfPassword.text!,"confirm_password":tfConfirmPassword.text!]
        print("the dict param is \(dictParam)")
        self.modelObject.getParamForChangepassword(param: dictParam)
    }
}

//Error handling Get Profile Api Here:-
extension ChangePasswordVC: ChangePasswordViewModelProtocol {
    
    func loginApiResponse(message: String, response: [String : Any], isError: Bool) {
        if !isError{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Password Changed Successfully", btnOkTitle: "DONE".localized()) {
                self.back()
            }
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
            }
        }
    }
    
   func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}

