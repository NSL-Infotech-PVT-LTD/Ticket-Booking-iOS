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
    
    @IBOutlet weak var conTView: UIView!
    @IBOutlet weak var showViewLan: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblRemember: UILabel!
    @IBOutlet var btnForget: UIButton!
    @IBOutlet var btnSign: UIButton!
    @IBOutlet var lblDontHaveAccount: UILabel!
    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var lblSignInToContinue: UILabel!    
    @IBOutlet weak var btnRememberMe: UIButton!
    
    //MARK:- Varaibles -
    var loginViewModel = LoginViewModel()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //        self.tfEmail.text = "rav@me.com"
        //        self.tfPassword.text = "12345678"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        loginViewModel.delegate = self
        
        
        self.showViewLan.isHidden = true
        self.conTView.isHidden = true

        
        self.lblWelcome.text = "WELCOME".localized()
        self.lblSignInToContinue.text = "SIGN_TO_CONTINUE".localized()
        
        self.lblEmail.text = "EMAIL_ADDRESS".localized()
        self.tfEmail.placeholder = "TYPE_HERE".localized()
        self.lblPassword.text = "PASSWORD".localized()
        self.tfPassword.placeholder = "TYPE_HERE".localized()
        
        self.lblRemember.text = "remember_me".localized()
        btnForget.setTitle("forget_password".localized(), for: .normal)
        
        self.lblDontHaveAccount.text = "DONT_HAVE_ACCOUNT".localized()
        btnSign.setTitle("SIGN_UP".localized(), for: .normal)
        
        self.btnLogin.setTitle("login".localized(), for: .normal)
        self.btnChange.setTitle("CHNAGE".localized(), for: .normal)
        
        if let boolValue = UserDefaults.standard.bool(forKey: "RememberMe") as? Bool {
            if boolValue == true{
                self.tfEmail.text = UserDefaults.standard.string(forKey: "UserName")
                self.tfPassword.text = UserDefaults.standard.string(forKey: "Password")
                btnRememberMe.setImage(UIImage(named: "tick_selected"), for: .normal)
                
            }else{
                btnRememberMe.setImage(UIImage(named: "tick_unselect"), for: .normal)
                
            }
        }else{
            btnRememberMe.setImage(UIImage(named: "tick_unselect"), for: .normal)
            
        }
        
        
    }
    
    //MARK:- Custom button's Action -
    @IBAction func btnSignupAction(_ sender: UIButton) {
        self.presentViewController(viewController : "SocialLoginVC", value: "Main")
    }
    
    
    
    @IBAction func btnGoBackAction(_ sender: UIButton) {
        self.showViewLan.isHidden = true
        self.conTView.isHidden = true
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = CATransitionType(rawValue: "flip")
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
       // conTView.layer.removeAnimation(forKey: kCATransition)
        showViewLan.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)

    }
    
    
    
    @IBAction func btnChangeLanguageAction(_ sender: UIButton) {
//        self.showViewLan.isHidden = false
//        self.conTView.isHidden = false
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: .linear)
//        transition.type = CATransitionType(rawValue: "flip")
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromTop
//        //conTView.layer.add(transition, forKey: kCATransition)
//        showViewLan.layer.add(transition, forKey: kCATransition)
//                let story = UIStoryboard(name: "Main", bundle:nil)
//                           let vc = story.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
//                let navController = UINavigationController(rootViewController: vc)
//                        vc.modalPresentationStyle = .overCurrentContext
//                       vc.hidesBottomBarWhenPushed = true
//                navController.pushViewController(vc, animated: true)
        
        self.presentViewController(viewController : "LanguageVC", value: "Main")
        
        
        
    }
    
    @IBAction func btnRemberAction(_ sender: UIButton) {
        
        
        if sender.isSelected{
            print("selected")
            
            UserDefaults.standard.set(false, forKey: "RememberMe")
            UserDefaults.standard.set("", forKey: "UserName")
            UserDefaults.standard.set("", forKey: "Password")
            
            btnRememberMe.setImage(UIImage(named: "tick_unselect"), for: .normal)
            
            
        }else{
            print("Unselected")
            UserDefaults.standard.set(true, forKey: "RememberMe")
            btnRememberMe.setImage(UIImage(named: "tick_selected"), for: .selected)
            
            
            
        }
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func btnForgetAction(_ sender: UIButton) {
        self.presentViewController(viewController : "ForgetPasswordVC", value: "Main")
    }
    
    @IBAction func btnHidePasswordAction(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.tfPassword.isSecureTextEntry = false
        }else{
            sender.isSelected = false
            self.tfPassword.isSecureTextEntry = true
        }
        
       
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        print(tfEmail.text?.count)
        print(tfEmail.text!)
        
        
        guard tfEmail.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: "ENTER_YOUR_MAIL".localized(), btnOkTitle: "DONE".localized()) {
            }
            return
        }
        guard tfPassword.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: "ENTER_YOUR_PASSWRD".localized(), btnOkTitle: "DONE".localized()) {
            }
            return
        }
        
        var param = [String : Any]()
        LoaderClass.shared.loadAnimation()
        let deviceToken = UserDefaults.standard.value(forKey: "device_token")
        print("the device token is \(deviceToken)")
        param = ["email":tfEmail.text! , "password" : tfPassword.text! , "device_type":"ios","device_token": deviceToken ?? ""]
        
        
        UserDefaults.standard.set(self.tfEmail.text!, forKey: "UserName")
        UserDefaults.standard.set(self.tfPassword.text!, forKey: "Password")
        
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
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.userID)
            let useriD = response["user"] as? [String:Any]
            
            print("the user id is \(useriD?["id"] ?? 0)")
            UserDefaults.standard.set(useriD?["id"] ?? 0, forKey:UserdefaultKeys.userID )
            UserDefaults.standard.set(useriD?["name"] ?? "", forKey:UserdefaultKeys.userName )
            
            UserDefaults.standard.set(useriD?["currency"] ?? "", forKey:UserdefaultKeys.userCurrency )
            
            self.stopAnimating()
            self.goToDashBoard()
            
            
            let userIDValue =   UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
            print("the user id is \(userIDValue)")
            
            
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
                
            }
        }
        
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
