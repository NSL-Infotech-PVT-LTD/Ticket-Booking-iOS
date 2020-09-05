//
//  ForgetPasswordVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 01/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var viewForget: UIView!
    @IBOutlet weak var viewHeader: UIView!
    
    //MARK:- Variables -
    var objectViewModel = ForgetPasswordViewModel()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objectViewModel.delegate = self
        self.viewForget.addBottomShadow()
        
    }
    
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        guard tfEmail.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Enter your email", btnOkTitle: "Done") {
            }
            return
        }
        LoaderClass.shared.loadAnimation()
        var param = [String : Any]()
        param = ["email":tfEmail.text!]
        objectViewModel.getParamForForgetPasswordView(param: param)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//Error handling Signup Api Here:-
extension ForgetPasswordVC: ForgetPasswordViewModelProtocol {
    func forgetPasswordApiResponse(message: String, response: [String : Any], isError: Bool) {
        LoaderClass.shared.stopAnimation()
        
        if !isError{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Success", message: message, btnOkTitle: "Done") {
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
                self.tfEmail.text = nil
            }
        }
    }
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
