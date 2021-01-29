//
//  SignupVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 28/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    
    //MARK:- Variables -
    lazy var viewModelObject = SignUpViewModel()
    
    //MARK:- Outlets -
    
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var btnBackToLogin: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
   @IBOutlet weak var lblRegisterTitle: UILabel!
    @IBOutlet weak var lblSurpriseTitle: UILabel!
    @IBOutlet weak var lblMeTitle: UILabel!
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblEmailAddress: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblCPassword: UILabel!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    
    //MARK:- View's Life Cycle -
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        viewModelObject.delegate = self
        self.viewHeader.addBottomShadow()
        self.btnBack.setTitle("back".localized(), for: .normal)
        self.lblMainTitle.text = "MAIN_TITLE".localized()
        self.lblRegisterTitle.text = "REGISTER_TITLE".localized()
        self.lblSurpriseTitle.text = "SURPRISE_TITLE".localized()
        self.lblMeTitle.text = "ME_TITLE".localized()
        self.lblUsername.text = "username".localized()
        self.tfUserName.placeholder = "TYPE_HERE".localized()
        self.lblEmailAddress.text = "EMAIL_ADDRESS".localized()
        self.tfEmail.placeholder = "TYPE_HERE".localized()
        self.lblPassword.text = "PASSWORD".localized()
        self.tfPassword.placeholder = "TYPE_HERE".localized()
        self.lblCPassword.text = "c_password".localized()
        self.tfConfirmPassword.placeholder = "TYPE_HERE".localized()
        self.btnRegister.setTitle("register_now".localized(), for: .normal)
        self.btnBackToLogin.setTitle("BACK_TO_LOGIN".localized(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Custom's Back Button Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: {
        })
    }
    
    
    @IBAction func btnConfPasswordAction(_ sender: UIButton) {
       
        
        if sender.isSelected == false{
            sender.isSelected = true
            self.tfConfirmPassword.isSecureTextEntry = false
        }else{
            sender.isSelected = false
            self.tfConfirmPassword.isSecureTextEntry = true
        }
        
        
        
        
    }
    
    @IBAction func btnPasswordVisibleAction(_ sender: UIButton) {
        
        
        if sender.isSelected == false{
            sender.isSelected = true
            self.tfPassword.isSecureTextEntry = false
        }else{
            sender.isSelected = false
            self.tfPassword.isSecureTextEntry = true
        }
        
        
        
      
        
    }
    
    //MARK:- Custom's Register Button Action -
    @IBAction func btnRegisterAction(_ sender: UIButton) {
      
        
        let password = tfConfirmPassword.text
        let confirmPassword = tfConfirmPassword.text

        if tfUserName.text?.count ?? 0  == 0{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_UserName, btnOkTitle: StringFile.OK) {
            }
        }else if tfEmail.text?.count ?? 0  == 0{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Email, btnOkTitle: StringFile.OK) {
            }
        }else if tfPassword.text?.count ?? 0  == 0{
           Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Password, btnOkTitle: StringFile.OK) {
            }
        }else if tfConfirmPassword.text?.count ?? 0  == 0{
           Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Confirm_Password, btnOkTitle: StringFile.OK) {
            }
        }else if tfPassword.text?.count ?? 0  < 8{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: "password_should_atleast_eight_character".localized(), btnOkTitle: StringFile.OK) {
             }
         }else if tfConfirmPassword.text?.count ?? 0  < 8{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Confirm_Password, btnOkTitle: StringFile.OK) {
             }
         }
        
        else if (tfPassword.text!) != (tfConfirmPassword.text!) {
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Password Does not match")
            
        }else {
            var param = [String : Any]()
            LoaderClass.shared.loadAnimation()
            
            let deviceToken = UserDefaults.standard.value(forKey: "device_token")
            param = [StringFile.Name:tfUserName.text! , StringFile.Email : tfEmail.text! , StringFile.Password : tfPassword.text! , StringFile.device_type:StringFile.iOS,StringFile.device_token:deviceToken ?? "","lang":"en"]
            viewModelObject.getParamForSignUp(param: param, url: Api.Register)
               }
      }
    
    //MARK:- Custom's Back to login Button Action -
    @IBAction func btnBackToLoginAction(_ sender: UIButton) {
        self.pushWithAnimate(StoryName :Storyboard.Main,Controller : ViewControllers.Login)
    }
}

//Error handling Signup Api Here:-
extension SignupVC: SignUpViewModelProtocol {
    func signupApiResponse(message: String, response: [String : Any], isError: Bool) {
      LoaderClass.shared.stopAnimation()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: message, btnOkTitle: StringFile.OK) {
            }
        }else{
            UserDefaults.standard.set(response["token"], forKey: UserdefaultKeys.token)
                  UserDefaults.standard.set(true, forKey: UserdefaultKeys.isLogin)
                  UserDefaults.standard.removeObject(forKey: UserdefaultKeys.userID)
                             let useriD = response["user"] as? [String:Any]
                             print("the user id is \(useriD?["id"] ?? 0)")
             UserDefaults.standard.set(useriD?["id"] ?? 0, forKey:UserdefaultKeys.userID )
            UserDefaults.standard.set(useriD?["name"] ?? "", forKey:UserdefaultKeys.userName )
            UserDefaults.standard.set(useriD?["is_notify"] ?? "", forKey:UserdefaultKeys.is_notify )
            self.goToDashBoard()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
