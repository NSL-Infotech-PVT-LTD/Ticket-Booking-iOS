//
//  SocialLoginVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 25/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SocialLoginVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var viewBackTOLogin: UIView!
    @IBOutlet weak var viewSignWithEmail: UIView!
    @IBOutlet weak var lblTermsCondition: UILabel!
    @IBOutlet weak var viewApple: UIView!
    
    //MARK:- Varaibles -
    var loginViewModel = SignUpViewModel()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setInitialSetUp()
        self.loginViewModel.delegate = self
    }
    
    //MARK:- Initial Setup Function -
    func setInitialSetUp()  {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 253/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        
        let partOne = NSMutableAttributedString(string: "By signing up, you are agree with our", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: "Terms & Conditions", attributes: yourOtherAttributes)
        partTwo.addAttribute(NSAttributedString.Key.underlineStyle,
                             value: NSUnderlineStyle.single.rawValue,
                             range: NSRange(location: 0, length: 18))
        
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        lblTermsCondition.attributedText = combination
        viewFacebook.isUserInteractionEnabled = true
        viewBackTOLogin.isUserInteractionEnabled = true
        viewSignWithEmail.isUserInteractionEnabled = true
        
        let tapviewFacebook = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewFacebook(_:)))
        viewFacebook.addGestureRecognizer(tapviewFacebook)
        
        let tapviewEmail = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewEmail(_:)))
        viewSignWithEmail.addGestureRecognizer(tapviewEmail)
        
        let tapviewLogin = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewLogin(_:)))
        viewBackTOLogin.addGestureRecognizer(tapviewLogin)
        
    }
    
    //MARK:- Tap Gesture Action -
    @objc func handletapviewFacebook(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((AccessToken.current) != nil){
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    var param = [String : Any]()
                                    var paramDict = [String : Any]()
                                    paramDict = result as? [String : Any] ?? [:]
                                    print(result!)
                                    LoaderClass.shared.loadAnimation()
                                    param = ["name":paramDict["name"] ?? "" , "email" : paramDict["email"] ?? "" , "password" : paramDict["id"] ?? "" , "device_type":"ios","device_token":"ios"]
                                    self.loginViewModel.getParamForSignUp(param: param)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnTerConditionAction(_ sender: UIButton) {
        selectedIdentifier = "Terms And Conditions"

        self.presentViewController(viewController : "TermsProfileVC", value: "Main")

    }
    
    @objc func handletapviewLogin(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true) {
        }
    }
    
    @objc func handletapviewEmail(_ sender: UITapGestureRecognizer? = nil) {
        self.presentViewController(viewController : "SignupVC", value: "Main")
    }
    
}


//Error handling Signup Api Here:-
extension SocialLoginVC: SignUpViewModelProtocol {
    func signupApiResponse(message: String, response: [String : Any], isError: Bool) {
        UserDefaults.standard.set(response["token"], forKey: UserdefaultKeys.token)
        UserDefaults.standard.set(true, forKey: UserdefaultKeys.isLogin)
        LoaderClass.shared.stopAnimation()
        if !isError{
            self.goToDashBoard()
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        LoaderClass.shared.stopAnimation()
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
