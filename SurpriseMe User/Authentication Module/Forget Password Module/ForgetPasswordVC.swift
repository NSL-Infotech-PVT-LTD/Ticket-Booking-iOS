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
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet var btnContinue: UIButton!
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
        
        self.btnBack.setTitle("back".localized(), for: .normal)
        self.lblEmail.text = "EMAIL_ADDRESS".localized()
        self.tfEmail.placeholder = "TYPE_HERE".localized()
        self.btnContinue.setTitle("continue".localized(), for: .normal)
    }
    
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        guard tfEmail.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: "ENTER_YOUR_MAIL".localized(), btnOkTitle: "Done") {
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
            Helper.showOKAlertWithCompletion(onVC: self, title: "SUCCESS".localized(), message: message, btnOkTitle: "DONE".localized()) {
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
                self.tfEmail.text = nil
            }
        }
    }
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
