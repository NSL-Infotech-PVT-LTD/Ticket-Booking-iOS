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
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    //MARK:- Variables -
    var objectViewModel = ProfileViewModel()
    var imagePicker = UIImagePickerController()
    var picker: UIImagePickerController = UIImagePickerController()
    
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
        let alert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
            self.objectViewModel.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handletapviewChangePassword(_ sender: UITapGestureRecognizer? = nil) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.Profile, Controller: ViewControllers.ChangePasswordVC)
    }
    
    //MARK:- Back Action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert!", message: "Do you want to save your profile?", preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            self.back()
              }))
         self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
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
        self.editProfileBtn.isHidden = false
        self.editImgBtn.isHidden = true
        self.updateBtn.isHidden = true
        self.tfUserName.isUserInteractionEnabled = false
        self.tfEmail.isUserInteractionEnabled = false
        objectViewModel.updataProfileData(param: ["name": self.tfUserName.text!], image: self.imgUserProfile.image ?? UIImage())
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        self.editProfileBtn.isHidden = true
        self.editImgBtn.isHidden = false
        self.updateBtn.isHidden = false
        self.tfUserName.isUserInteractionEnabled = true
        self.tfEmail.isUserInteractionEnabled = false
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
    
    func getUpdateProfileApiResponse(message: String , isError : Bool){
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "profile has been updated succesfully", btnOkTitle: "Done") {
                self.objectViewModel.getParamForGetProfile(param: [:])
            }
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


extension ProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagedata = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imgUserProfile.image = imagedata
        }
        self.imgUserProfile.contentMode = .scaleAspectFill
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
}
