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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Custom's Back Button Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: {
        })
    }
    
    //MARK:- Custom's Register Button Action -
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        guard tfUserName.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_UserName, btnOkTitle: StringFile.OK) {
            }
            return
        }
        guard tfEmail.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Email, btnOkTitle: StringFile.OK) {
            }
            return
        }
        guard tfPassword.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Password, btnOkTitle: StringFile.OK) {
            }
            return
        }
        guard tfConfirmPassword.text?.count ?? 0 > 0 else {
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: StringFile.Enter_Confirm_Password, btnOkTitle: StringFile.OK) {
            }
            return
        }
        var param = [String : Any]()
        LoaderClass.shared.loadAnimation()
        param = [StringFile.Name:tfUserName.text! , StringFile.Email : tfEmail.text! , StringFile.Password : tfPassword.text! , StringFile.device_type:StringFile.iOS,StringFile.device_token:StringFile.iOS]
        viewModelObject.getParamForSignUp(param: param)
    }
    
    //MARK:- Custom's Back to login Button Action -
    @IBAction func btnBackToLoginAction(_ sender: UIButton) {
        self.pushWithAnimate(StoryName :Storyboard.Main,Controller : ViewControllers.Login)
    }
}

//Error handling Signup Api Here:-
extension SignupVC: SignUpViewModelProtocol {
    func signupApiResponse(message: String, response: [String : Any], isError: Bool) {
        UserDefaults.standard.set(response["token"], forKey: UserdefaultKeys.token)
        UserDefaults.standard.set(true, forKey: UserdefaultKeys.isLogin)
        LoaderClass.shared.stopAnimation()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: message, btnOkTitle: StringFile.OK) {
            }
        }else{
            self.goToDashBoard()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
