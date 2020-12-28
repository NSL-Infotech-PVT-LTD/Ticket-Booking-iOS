//
//  ChangePasswordVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    
    
    //MARK:- Variale -
    var modelObject = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addBottomShadow()
        modelObject.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        
        guard oldPassword.text?.count ?? 0 > 0 else {
                          Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Enter your old password", btnOkTitle: "Done") {
                          }
                          return
                      }
                      guard tfPassword.text?.count ?? 0 > 0 else {
                          Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Enter your password", btnOkTitle: "Done") {
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
            
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Password Changed Successfully", btnOkTitle: "Done") {
                self.back()
            }
            
            
           }else{
               Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
                  
               }
           }
           
       }
   
    
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}

