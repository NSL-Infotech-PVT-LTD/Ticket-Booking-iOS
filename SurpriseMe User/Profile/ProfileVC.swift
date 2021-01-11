//
//  ProfileVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AlamofireImage
import AVFoundation
import AVKit
import Mantis
class ProfileVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewAboutUs: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    
    @IBOutlet weak var lblProfile: UILabel!
    
    
    @IBOutlet weak var lblChangePasssword: UILabel!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    //MARK:- Variables -
    var objectViewModel = ProfileViewModel()
    var imagePicker = UIImagePickerController()
    var picker: UIImagePickerController = UIImagePickerController()
    var isUpdateProfile = Bool()
    
    //MARK:- View's Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setInitialSetup()
        self.setLocalisation()
        self.viewHeader.addBottomShadow()
        logoutView.isHidden = false
        viewAboutUs.isHidden = false
        viewChangePassword.isHidden = false
        
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapview(_:)))
        imgUserProfile.addGestureRecognizer(tapviewAboutUs)
        self.imgUserProfile.isUserInteractionEnabled = false
    }
    
    
    func setLocalisation(){
        self.lblProfile.text = "PROFILE".localized()
        self.lblUserName.text = "USER_NAME".localized()
        self.lblEmail.text = "EMAIL".localized()
        self.lblLogout.text = "LOGOUT".localized()
        self.lblSettings.text = "SETTING".localized()
        self.lblChangePasssword.text = "CHANGE_PASSSWORD".localized()
        self.editProfileBtn.setTitle("EDIT_PROFILE".localized(), for: .normal)
        btnBack.setTitle("back".localized(), for: .normal)
        self.updateBtn.setTitle("UPDATE_PROFILE_CUSTOMER".localized(), for: .normal)
 }
    
    @objc func handletapview(_ sender: UITapGestureRecognizer? = nil) {
        let alert = UIAlertController(title: "", message: "PLEASE_SELECT_OPTION".localized(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "CAMERA".localized(), style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "GALLERY".localized(), style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel , handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    
    //MARK:- Setup View and Calling Api's -
    func setInitialSetup()  {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.imagePicker.delegate = self
        self.editProfileBtn.isHidden = false
        self.editImgBtn.isHidden = true
        self.updateBtn.isHidden = true
        self.tfUserName.isUserInteractionEnabled = false
        self.tfEmail.isUserInteractionEnabled = false
        objectViewModel.delegate = self
        objectViewModel.getParamForGetProfile(param: [:])
        let tapviewLogin = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewLogin(_:)))
        logoutView.addGestureRecognizer(tapviewLogin)
        let tapviewChangePassword = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewChangePassword(_:)))
        viewChangePassword.addGestureRecognizer(tapviewChangePassword)
        
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAboutUs(_:)))
        viewAboutUs.addGestureRecognizer(tapviewAboutUs)
    }
    
    //MARK:- Handling Tap Gesture -
    
    @objc func handletapviewAboutUs(_ sender: UITapGestureRecognizer? = nil)
    {
        self.pushWithAnimateDirectly(StoryName: Storyboard.Profile, Controller: ViewControllers.SettingVC)
    }
    
    @objc func handletapviewLogin(_ sender: UITapGestureRecognizer? = nil) {
        let alert = UIAlertController(title: "ALERT".localized(), message: "DO_YOU_WANT_LOGOUT".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.destructive, handler: { action in
            self.objectViewModel.logout()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handletapviewChangePassword(_ sender: UITapGestureRecognizer? = nil) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.Profile, Controller: ViewControllers.ChangePasswordVC)
    }
    
    //MARK:- Back Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        if isUpdateProfile == true{
            let alert = UIAlertController(title: "ALERT".localized(), message: "DO_WANT_PROFILE".localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.default, handler: { action in
                
                if self.tfUserName.text == ""{
                    self.showSimpleAlert(Title: "ALERT".localized(), message: "PLEASE_ENTER_USERNAME".localized(), inClass: self)
                }else{
                    self.editProfileBtn.isHidden = false
                    self.editImgBtn.isHidden = true
                    self.updateBtn.isHidden = true
                    self.isUpdateProfile = false
                    self.logoutView.isHidden = false
                    self.viewAboutUs.isHidden = false
                    self.viewChangePassword.isHidden = false
                    self.tfUserName.isUserInteractionEnabled = false
                    self.tfEmail.isUserInteractionEnabled = false
                    self.objectViewModel.updataProfileData(param: ["name": self.tfUserName.text!], image: self.imgUserProfile.image ?? UIImage())
                }
            }))
            
            alert.addAction(UIAlertAction(title: "NO".localized(), style: UIAlertAction.Style.default, handler: { action in
                self.back()
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
//            self.btnUpdateProfileAction(self.updateBtn)
             self.back()
        }
  }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "", message: "PLEASE_SELECT_OPTION".localized(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "CAMERA".localized(), style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "GALLERY".localized(), style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel , handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func openGallery()  {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.addChild(picker)
        picker.didMove(toParent: self)
        self.view!.addSubview(picker.view!)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.addChild(imagePicker)
            imagePicker.didMove(toParent: self)
            self.view!.addSubview(imagePicker.view!)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func btnUpdateProfileAction(_ sender: UIButton) {
        if self.tfUserName.text == ""{
            self.showSimpleAlert(Title: "YES".localized(), message: "PLEASE_ENTER_USERNAME".localized(), inClass: self)
        }else{
            self.editProfileBtn.isHidden = false
            self.editImgBtn.isHidden = true
            self.updateBtn.isHidden = true
            isUpdateProfile = false
            logoutView.isHidden = false
            viewAboutUs.isHidden = false
            viewChangePassword.isHidden = false
            self.tfUserName.isUserInteractionEnabled = false
            self.tfEmail.isUserInteractionEnabled = false
            objectViewModel.updataProfileData(param: ["name": self.tfUserName.text!], image: self.imgUserProfile.image ?? UIImage())
        }
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        self.editProfileBtn.isHidden = true
        self.editImgBtn.isHidden = false
        self.updateBtn.isHidden = false
        logoutView.isHidden = true
        viewAboutUs.isHidden = true
        viewChangePassword.isHidden = true
        self.tfUserName.isUserInteractionEnabled = true
        self.tfEmail.isUserInteractionEnabled = false
        self.imgUserProfile.isUserInteractionEnabled = true
        isUpdateProfile = true
        self.tfUserName.becomeFirstResponder()
    }
    
    func getProfileData(profile :GetProfileModel? )  {
        self.tfUserName.text = profile?.name ?? ""
        self.tfEmail.text = profile?.email ?? ""
        
        var urlSting : String = "\(Api.imageURL)\(profile?.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let urlImage = URL(string: urlStringaa)!
        self.imgUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgUserProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        if profile?.image == ""{
            self.imgUserProfile.isUserInteractionEnabled = false
        }else{
            self.imgUserProfile.isUserInteractionEnabled = true
        }
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
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.userID)
//            UserDefaults.standard.set(0, forKey: UserdefaultKeys.userID)
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.token)
            UserDefaults.standard.removeObject(forKey: UserdefaultKeys.userCurrency)
            UserDefaults.standard.setValue("", forKey: UserdefaultKeys.userCurrency)
            UserDefaults.standard.set(false, forKey: UserdefaultKeys.isLogin)
            LoaderClass.shared.stopAnimation()
            showTypeTrueOrFalse = false
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() 
            self.goToLogin()
        }
    }
    
    func getUpdateProfileApiResponse(message: String , isError : Bool){
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
            }
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "PROFILE_UPDATE_SUCCESS".localized(), btnOkTitle: "DONE".localized()) {
                //self.objectViewModel.getParamForGetProfile(param: [:])
            }
        }
    }
    
    func getProfileApiResponse(message: String, response: GetProfileModel?, isError: Bool) {
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "ERROR".localized(), message: message, btnOkTitle: "DONE".localized()) {
            }
        }else{
            
            self.getProfileData(profile: response)
        }
    }
    
    func getProfileApiResponse(message: String, response: [String : Any], isError: Bool) {
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
        if errorMessage == "Invalid AUTH Token"{
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
                // do something like...
                UserDefaults.standard.set(nil, forKey: UserdefaultKeys.token)
                UserDefaults.standard.removeObject(forKey: UserdefaultKeys.token)
                
//                UserDefaults.standard.set(nil, forKey: UserdefaultKeys.token)
                UserDefaults.standard.removeObject(forKey: UserdefaultKeys.userID)
                UserDefaults.standard.set(false, forKey: UserdefaultKeys.isLogin)
                self.goToLogin()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
            Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
            
        }
        
    }
}


extension ProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagedata = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            let cropViewController = Mantis.cropViewController(image: imagedata)
            cropViewController.delegate = self
            cropViewController.modalPresentationStyle = .overCurrentContext
            self.present(cropViewController,animated: true)
        }
//        self.imgUserProfile.contentMode = .scaleAspectFill
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
}


extension ProfileVC:CropViewControllerDelegate{
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.imgUserProfile.image = cropped
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
