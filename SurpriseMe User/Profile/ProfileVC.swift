//
//  ProfileVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewAboutUs: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    
    
    //MARK:- Variables -
    var objectViewModel = ProfileViewModel()
    
    //MARK:- View's Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setInitialSetup()
        self.viewHeader.addBottomShadow()
    }
    
    //MARK:- Setup View and Calling Api's -
    func setInitialSetup()  {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        objectViewModel.delegate = self
        objectViewModel.getParamForGetProfile(param: [:])
        let tapviewLogin = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewLogin(_:)))
        logoutView.addGestureRecognizer(tapviewLogin)
    }
    
    //MARK:- Handling Tap Gesture -
    @objc func handletapviewLogin(_ sender: UITapGestureRecognizer? = nil) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
            // do something like...
            self.objectViewModel.logout()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
   
    //MARK:- Back Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
    }
    
    func getProfileData(profile :GetProfileModel? )  {
        self.tfUserName.text = profile?.name ?? ""
        self.tfEmail.text = profile?.email ?? ""
    }
    
    
}

//Error handling Get Profile Api Here:-
extension ProfileVC: ProfileViewModelProtocol {
    
    func logoutResponse(isError: Bool, errorMessage: String){
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: errorMessage, btnOkTitle: "Done") {
            }
        }else{
            UserDefaults.standard.set(nil, forKey: UserdefaultKeys.token)
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.token)
            UserDefaults.standard.set(false, forKey: UserdefaultKeys.isLogin)
            LoaderClass.shared.stopAnimation()
            self.goToLogin()
        }
        
    }
    func getProfileApiResponse(message: String, response: GetProfileModel?, isError: Bool) {
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            self.getProfileData(profile: response)
        }
    }
    
    func getProfileApiResponse(message: String, response: [String : Any], isError: Bool) {
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
    }
}
