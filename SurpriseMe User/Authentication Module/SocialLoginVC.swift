//
//  SocialLoginVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 25/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices

class SocialLoginVC: UIViewController {
    
    //MARK:- Outlets -
    
    @IBOutlet var lblMainTitle: UILabel!
    @IBOutlet var lblAreYouNew: UILabel!
    @IBOutlet var lblSignUpWithEmail: UILabel!
    @IBOutlet var lblOr: UILabel!
    @IBOutlet var lblSignupWithFacebook: UILabel!
    @IBOutlet var lblSignupWithApple: UILabel!
    @IBOutlet var lblBackToLogin: UILabel!
    @IBOutlet weak var lblTermsANDCond: UILabel!
    @IBOutlet weak var lblSigningUpAgree: UILabel!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var viewBackTOLogin: UIView!
    @IBOutlet weak var viewSignWithEmail: UIView!
    @IBOutlet weak var lblTermsCondition: UILabel!
    @IBOutlet weak var viewApple: UIView!
    
    //MARK:- Varaibles -
    var loginViewModel = SignUpViewModel()
    let fbLoginManager : LoginManager = LoginManager()
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setInitialSetUp()
        self.loginViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblMainTitle.text = "register_title".localized()
        self.lblAreYouNew.text = "are_you_new".localized()
        self.lblSignUpWithEmail.text = "signup_with_email".localized()
        self.lblOr.text = "or".localized()
        self.lblSigningUpAgree.text = "by_signup".localized()
        self.lblTermsANDCond.text = "terms_condition".localized()
        self.lblSignupWithFacebook.text = "signup_with_facebook".localized()
        self.lblSignupWithApple.text = "signup_with_apple".localized()
        self.lblBackToLogin.text = "back_to_login".localized()
        
        if #available(iOS 13, *) {
            self.viewApple.isHidden = false
            self.viewApple.isUserInteractionEnabled = true
            let tapviewApple = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAppleLogin(_:)))
            viewApple.addGestureRecognizer(tapviewApple)
        }else{
            self.viewApple.isHidden = true
            self.viewApple.isUserInteractionEnabled = false
        }
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
        
        fbLoginManager.logOut()
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
                                    let deviceToken = UserDefaults.standard.value(forKey: "device_token") as? String
                                    let imageData = paramDict["picture"] as? [String:Any]
                                    let imagePictureData = imageData?["data"] as? [String:Any]
                                    let image = imagePictureData?["url"] as? String
                                    LoaderClass.shared.loadAnimation()
                                    let language = UserDefaults.standard.value(forKey: "app_lang") as? String ?? ""
                                    
                                    param = ["name":paramDict["name"] ?? "" , "email" : paramDict["email"] ?? "" , "fb_id" : paramDict["id"] ?? "" , "device_type":"ios","device_token":deviceToken ?? "","lang":language,"image":image ?? ""]
                                    self.loginViewModel.getParamForSignUp(param: param, url: Api.FBregister)
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
       
        
        LoaderClass.shared.stopAnimation()
        if !isError{
            UserDefaults.standard.set(response["token"] ?? "", forKey: UserdefaultKeys.token)
            UserDefaults.standard.set(true, forKey: UserdefaultKeys.isLogin)
            if let data = response["user"] as? [String:Any]{
                UserDefaults.standard.set(data["id"] as? Int, forKey: UserdefaultKeys.userID)
                if let currancy = data["currency"] as? String{
                    UserDefaults.standard.set(currancy, forKey: UserdefaultKeys.userCurrency)
                }
            }
            self.goToDashBoard()
            
            let userIDValue =   UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
            print("the user id is \(userIDValue)")
            
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

@available(iOS 13, *)
extension SocialLoginVC:ASAuthorizationControllerDelegate{
    @objc func handletapviewAppleLogin(_ sender: UITapGestureRecognizer? = nil) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        LoaderClass.shared.loadAnimation()
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let appleIDProvider = ASAuthorizationAppleIDProvider()
                    appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                         switch credentialState {
                            case .authorized:
                                // The Apple ID credential is valid.
                                print("Done")
                                let _ = appleIDCredential.fullName
                                let _ = appleIDCredential.email
                                let JWT = appleIDCredential.identityToken!
                                let str = String(decoding: JWT, as: UTF8.self)
                                let data = self.decode(str)
                                print(data)
                                let deviceToken = UserDefaults.standard.value(forKey: "device_token") as? String
                                let param = ["email": "\(appleIDCredential.email ?? "")" ,"apple_id":"\(userIdentifier)" ,"name":"\(appleIDCredential.fullName?.givenName ?? "")" ,"device_type":"ios","device_token":deviceToken ?? "","lang":"en"] as [String : Any]
                                
                                self.loginViewModel.getParamForSignUp(param: param, url: Api.AppleLogin)
                                break
                            case .revoked:
                                // The Apple ID credential is revoked.
                                print("revoked")
                                LoaderClass.shared.stopAnimation()
                                break
                         case .notFound:
                            LoaderClass.shared.stopAnimation()
                            print("No credential")
                            break
                                // No credential was found, so show the sign-in UI.
                            default:
                                break
                         }
                    }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    func decode(_ token: String) -> [String: AnyObject]? {
      let string = token.components(separatedBy: ".")
      let toDecode = string[1] as String


      var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
      stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
      switch (stringtoDecode.utf16.count % 4) {
      case 2: stringtoDecode = "\(stringtoDecode)=="
      case 3: stringtoDecode = "\(stringtoDecode)="
      default: // nothing to do stringtoDecode can stay the same
          print("")
      }
      let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
      let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)

      var values: [String: AnyObject]?
      if let string = base64DecodedString {
          if let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) {
              values = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
          }
      }
      return values
  }
}

