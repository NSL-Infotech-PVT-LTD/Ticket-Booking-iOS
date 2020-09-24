//
//  LoginVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 26/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginVC: UIViewController , NVActivityIndicatorViewable{
    
    //MARK:- Outlets -
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    //MARK:- Varaibles -
    var loginViewModel = LoginViewModel()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        loginViewModel.delegate = self
       
       
    }
    
    //MARK:- Custom button's Action -
    @IBAction func btnSignupAction(_ sender: UIButton) {
        self.presentViewController(viewController : "SocialLoginVC", value: "Main")
    }
    
    @IBAction func btnRemberAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnForgetAction(_ sender: UIButton) {
        self.presentViewController(viewController : "ForgetPasswordVC", value: "Main")
    }
    
    @IBAction func btnHidePasswordAction(_ sender: UIButton) {
        if  sender.isSelected == false{
            sender.isSelected = true
            self.tfPassword.isSecureTextEntry = false
            //btnPasswordConfirm.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }else{
            sender.isSelected = false
            self.tfPassword.isSecureTextEntry = true
           // btnPasswordConfirm.setImage(#imageLiteral(resourceName: "icons8-hide-24"), for: .normal)
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        guard tfEmail.text?.count ?? 0 > 0 else {
                   Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Enter your email", btnOkTitle: "Done") {
                   }
                   return
               }
               guard tfPassword.text?.count ?? 0 > 0 else {
                   Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Enter your password", btnOkTitle: "Done") {
                   }
                   return
               }
        
        var param = [String : Any]()
        LoaderClass.shared.loadAnimation()
        param = ["email":tfEmail.text! , "password" : tfPassword.text! , "device_type":"ios","device_token": "ios"]
        loginViewModel.getParamForLogin(param: param)
    }
    
    
}

//Error handling Signup Api Here:-
extension LoginVC: LoginViewModelProtocol {
    func loginApiResponse(message: String, response: [String : Any], isError: Bool) {
        LoaderClass.shared.stopAnimation()

        if !isError{
            UserDefaults.standard.set(response["token"], forKey: UserdefaultKeys.token)
            UserDefaults.standard.set(true, forKey: UserdefaultKeys.isLogin)
            self.stopAnimating()
            self.goToDashBoard()
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
                self.tfEmail.text = nil
                self.tfPassword.text = nil
            }
        }
        
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
